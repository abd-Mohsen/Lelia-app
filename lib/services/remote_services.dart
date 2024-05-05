import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:lelia/models/user_model.dart';
import '../constants.dart';

//todo: implement 'session expired'
class RemoteServices {
  static final String _hostIP = "$kHostIP/api";
  static String get token => GetStorage().read("token");
  static Map<String, String> headers = {
    "Accept": "Application/json",
    'Content-Type': 'application/json',
  };
  static Map<String, String> headersAuth = {
    "Accept": "Application/json",
    "Auth": "Bearer $token",
    'Content-Type': 'application/json',
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

  static Future<List<UserModel>?> getSupervisors() async {
    var response = await client.get(
      Uri.parse("$_hostIP/users/supervisors"),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return userModelFromJson(response.body);
    }
    print(response.body);
    return null;
  }

  static Future<String?> sendRegisterOtp() async {
    var response = await client.get(
      Uri.parse("$_hostIP/email/send-otp-code"),
      headers: {
        'Content-Type': 'application/json',
        "Accept": 'application/json',
        "Authorization": "Bearer $token",
      },
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
      headers: {
        'Content-Type': 'application/json',
        "Accept": 'application/json',
        "Authorization": "Bearer $token",
      },
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
      headers: {
        'Content-Type': 'application/json',
        "Accept": 'application/json',
        //"Authorization": "Bearer $token",
      },
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
      headers: {
        'Content-Type': 'application/json',
        "Accept": 'application/json',
        //"Authorization": "Bearer $token",
      },
    );
    print(response.body);
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
      headers: {
        'Content-Type': 'application/json',
        "Accept": 'application/json',
      },
    );
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      Get.defaultDialog(title: "error".tr, middleText: jsonDecode(response.body)["message"]);
      return false;
    }
  }
}
