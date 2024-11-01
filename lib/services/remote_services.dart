import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:lelia/models/login_model.dart';
import 'package:lelia/models/report_model.dart';
import 'package:lelia/models/user_model.dart';
import 'package:path/path.dart';
import '../constants.dart';
import 'package:lelia/main.dart';
import 'package:flutter/material.dart';

//todo: implement 'session expired'
//todo: clean this shit up, make separate services
// todo: all dialogs here are broken with light mode
//todo: remove get default dialogs from here
//todo: remove timeout dialogs from controllers
class RemoteServices {
  static final GetStorage _getStorage = GetStorage();
  static final String _hostIP = "$kHostIP/api";
  static String get token => GetStorage().read("token");

  static Map<String, String> headers = {
    "Accept": "Application/json",
    "Content-Type": "application/json",
    "sent-from": "mobile",
  };

  static var client = http.Client();

  static Future<bool> register(
    String userName,
    String email,
    String password,
    String passwordConfirmation,
    String phone,
    String role,
    int? supervisorId,
  ) async {
    Map<String, dynamic> body = {
      "name": userName,
      "email": email,
      "password": password,
      "password_confirmation": passwordConfirmation,
      "role": role,
      "phone": phone,
      if (supervisorId != null) "supervisor_id": supervisorId,
    };
    String? json = await api.postRequest("register", body, auth: false);
    if (json == null) {
      Get.defaultDialog(
        titleStyle: const TextStyle(color: Colors.black),
        middleTextStyle: const TextStyle(color: Colors.black),
        backgroundColor: Colors.white,
        title: "خطأ",
        middleText: "يرجى التأكد من البيانات المدخلة أو المحاولة مجدداً",
      );
      return false;
    }
    return true;
  }

  static Future<LoginModel?> login(String email, String password) async {
    Map<String, dynamic> body = {
      "email": email,
      "password": password,
    };
    String? json = await api.postRequest("login", body, auth: false);
    if (json == null) {
      Get.defaultDialog(
        titleStyle: const TextStyle(color: Colors.black),
        middleTextStyle: const TextStyle(color: Colors.black),
        backgroundColor: Colors.white,
        title: "خطأ",
        middleText: "يرجى التأكد من البيانات المدخلة و المحاولة مجدداً, قد يكون الاتصال ضعيف, أو الحساب غير مفعل من "
            "الشركة",
      );
      return null;
    }
    return LoginModel.fromJson(jsonDecode(json));
  }

  static Future<bool> logout() async {
    String? json = await api.getRequest("logout", auth: true);
    return json != null;
  }

  static Future<UserModel?> fetchCurrentUser() async {
    String? json = await api.getRequest("users/profile", auth: true);
    if (json == null) return null;
    return UserModel.fromJson(jsonDecode(json));
  }

  static Future<List<UserModel>?> fetchSupervisors() async {
    String? json = await api.getRequest("users/supervisors", auth: false);
    if (json == null) return null;
    return userModelFromJson(json);
  }

  static Future<String?> sendRegisterOtp() async {
    String? json = await api.getRequest("email/send-otp-code", auth: true);
    if (json == null) return null;
    return jsonDecode(json)["url"];
  }

  static Future<bool> verifyRegisterOtp(String apiUrl, String otp) async {
    Map<String, dynamic> body = {"otp_code": otp};
    String? json = await api.postRequest(apiUrl, body, auth: true);
    if (json == null) {
      Get.defaultDialog(
        titleStyle: const TextStyle(color: Colors.black),
        middleTextStyle: const TextStyle(color: Colors.black),
        backgroundColor: Colors.white,
        title: "خطأ",
        middleText: "يرجى التأكد من البيانات المدخلة و المحاولة مجدداً قد يكون الاتصال ضعيف ",
      );
      return false;
    }
    return true;
  }

  static Future<bool> sendForgotPasswordOtp(String email) async {
    Map<String, dynamic> body = {"email": email};
    String? json = await api.postRequest("send-reset-otp", body, auth: false);
    return json == null;
  }

  static Future<String?> verifyForgotPasswordOtp(String email, String otp) async {
    Map<String, dynamic> body = {"email": email, "otp": otp};
    String? json = await api.postRequest("verify-reset-otp", body, auth: false);
    if (json == null) return null;
    return jsonDecode(json)["reset_token"];
  }

  static Future<bool> resetPassword(String email, String password, String resetToken) async {
    Map<String, dynamic> body = {
      "email": email,
      "password": password,
      "password_confirmation": password,
      "token": resetToken,
    };
    String? json = await api.postRequest("reset-password", body, auth: true);
    return json == null;
  }

  static Future<bool> uploadReport(ReportModel report) async {
    var request = http.MultipartRequest("POST", Uri.parse("$_hostIP/reports"));

    request.fields.addAll(report.toJson());
    request.headers.addAll({...headers, "Authorization": "Bearer $token"});

    for (var imagePath in report.images) {
      File imageFile = File(imagePath);
      var stream = http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();
      var multipartFile = http.MultipartFile(
        'images[]',
        stream,
        length,
        filename: basename(imageFile.path),
      );
      request.files.add(multipartFile);
    }

    var response = await request.send();
    print(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    }
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
    return false;
  }

  static Future<List<ReportModel>?> fetchSalesmanReports(int page, int limit) async {
    var response = await client.get(
      Uri.parse("$_hostIP/reports?page=$page&limit=$limit"),
      headers: {...headers, "Authorization": "Bearer $token"},
    );
    print(response.body);
    print(token);
    if (response.statusCode == 200) {
      var reports = reportModelFromJson(response.body);
      print("returned fine");
      return reports;
    }
    Get.defaultDialog(title: "error", middleText: jsonDecode(response.body)["message"]);
    return null;
  }

  static Future<List<ReportModel>?> fetchSubordinateReports(int id, int page, int limit) async {
    var response = await client.get(
      Uri.parse("$_hostIP/reports/$id?page=$page&limit=$limit"),
      headers: {...headers, "Authorization": "Bearer $token"},
    );
    print(response.body);
    print(token);
    if (response.statusCode == 200) {
      var reports = reportModelFromJson(response.body);
      print("returned fine");
      return reports;
    }
    Get.defaultDialog(title: "error", middleText: jsonDecode(response.body)["message"]);
    return null;
  }

  static Future<List<ReportModel>?> fetchSupervisorReports(int page, int limit) async {
    var response = await client.get(
      Uri.parse("$_hostIP/reports/supervisor/?page=$page&limit=$limit"),
      headers: {...headers, "Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      var reports = reportModelFromJson(response.body);
      return reports;
    }
    Get.defaultDialog(title: "error", middleText: jsonDecode(response.body)["message"]);
    return null;
  }

  static Future<List<UserModel>?> fetchSupervisorSubordinates() async {
    var response = await client.get(
      Uri.parse("$_hostIP/users/my-subs"),
      headers: {...headers, "Authorization": "Bearer $token"},
    );
    print(response.body);
    if (response.statusCode == 200) {
      return userModelFromJson(response.body);
    }
    Get.defaultDialog(title: "error", middleText: jsonDecode(response.body)["message"]);
    return null;
  }

  static Future<List<ReportModel>?> fetchExportedReports(String date1, String date2, int? salesmanID) async {
    var response = await client.post(
      Uri.parse("$_hostIP/reports/export"),
      headers: {...headers, "Authorization": "Bearer $token"},
      body: jsonEncode({
        "start_date": date1,
        "end_date": date2,
        "user_id": salesmanID,
      }),
    );
    print(response.body);
    print(token);
    if (response.statusCode == 200) {
      var reports = reportModelFromJson(response.body);
      print("returned fine");
      return reports;
    }
    Get.defaultDialog(title: "error", middleText: jsonDecode(response.body)["message"]);
    return null;
  }
}
