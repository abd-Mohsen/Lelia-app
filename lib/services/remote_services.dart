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

//todo: implement 'session expired'
//todo: clean this shit up, make separate services
// todo: all dialogs here are broken with light mode
class RemoteServices {
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
    var response = await client.post(
      Uri.parse("$_hostIP/register"),
      headers: headers,
      body: jsonEncode({
        "name": userName,
        "email": email,
        "password": password,
        "password_confirmation": passwordConfirmation,
        "role": role,
        "phone": phone,
        "supervisor_id": supervisorId,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    }
    Get.defaultDialog(
      title: "خطأ",
      middleText: jsonDecode(response.body)["message"],
    );
    return false;
  }

  static Future<LoginModel?> login(String email, String password) async {
    var response = await client.post(
      Uri.parse("$_hostIP/login"),
      headers: headers,
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return LoginModel.fromJson(jsonDecode(response.body));
    }
    if (response.statusCode == 422) {
      Get.defaultDialog(
        title: "خطأ",
        middleText: "البربد الاكتروني او كلمة المرور غير صحيحين",
      );
      return null;
    }
    Get.defaultDialog(
      title: "خطأ",
      middleText: jsonDecode(response.body)["message"],
    );
    return null;
  }

  static Future<bool> logout() async {
    var response = await client.get(
      Uri.parse("$_hostIP/logout"),
      headers: {...headers, "Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      return true;
    }
    if (response.statusCode == 401) {
      Get.dialog(kSessionExpiredDialog());
      return true;
    }
    return false;
  }

  static Future<UserModel?> fetchCurrentUser() async {
    var response = await client.get(
      Uri.parse("$_hostIP/users/profile"),
      headers: {...headers, "Authorization": "Bearer $token"},
    );
    print("${response.body}+${response.statusCode}");
    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    }
    if (response.statusCode == 401) {
      Get.dialog(kSessionExpiredDialog());
    }
    return null;
  }

  static Future<List<UserModel>?> fetchSupervisors() async {
    var response = await client.get(
      Uri.parse("$_hostIP/users/supervisors"),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return userModelFromJson(response.body);
    }
    return null;
  }

  static Future<String?> sendRegisterOtp() async {
    var response = await client.get(
      Uri.parse("$_hostIP/email/send-otp-code"),
      headers: {...headers, "Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body)["url"];
    } else {
      Get.defaultDialog(title: "error".tr, middleText: jsonDecode(response.body)["message"]);
      return null;
    }
  }

  static Future<bool> verifyRegisterOtp(String apiUrl, String otp) async {
    var response = await client.post(
      Uri.parse(apiUrl),
      body: jsonEncode({"otp_code": otp}),
      headers: {...headers, "Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      Get.defaultDialog(title: "error".tr, middleText: jsonDecode(response.body)["message"]);
      return false;
    }
  }

  static Future<bool> sendForgotPasswordOtp(String email) async {
    var response = await client.post(
      Uri.parse("$_hostIP/send-reset-otp"),
      headers: headers,
      body: jsonEncode({"email": email}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      Get.defaultDialog(title: "error".tr, middleText: jsonDecode(response.body)["message"]);
      return false;
    }
  }

  static Future<String?> verifyForgotPasswordOtp(String email, String otp) async {
    var response = await client.post(
      Uri.parse("$_hostIP/verify-reset-otp"),
      body: jsonEncode({"email": email, "otp": otp}),
      headers: headers,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body)["reset_token"];
    } else {
      Get.defaultDialog(title: "error".tr, middleText: jsonDecode(response.body)["message"]);
      return null;
    }
  }

  static Future<bool> resetPassword(String email, String password, String resetToken) async {
    var response = await client.post(
      Uri.parse("$_hostIP/reset-password"),
      body: jsonEncode({
        "email": email,
        "password": password,
        "password_confirmation": password,
        "token": resetToken,
      }),
      headers: headers,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      Get.defaultDialog(title: "error".tr, middleText: jsonDecode(response.body)["message"]);
      return false;
    }
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

  static Future<List<ReportModel>?> fetchSalesmanReports() async {
    var response = await client.get(
      Uri.parse("$_hostIP/reports"),
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

  static Future<List<ReportModel>?> fetchSubordinateReports(int id) async {
    var response = await client.get(
      Uri.parse("$_hostIP/reports/$id"),
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

  static Future<List<ReportModel>?> fetchSupervisorReports() async {
    var response = await client.get(
      Uri.parse("$_hostIP/reports/supervisor"),
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
