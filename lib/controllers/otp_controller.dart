import 'package:get/get.dart';
import 'package:lelia/controllers/reset_password_controller.dart';
import 'package:lelia/views/home_view.dart';
import 'package:lelia/views/login_view.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:timer_count_down/timer_controller.dart';
import '../constants.dart';
import '../services/remote_services.dart';
import '../views/reset_password_view2.dart';
import 'package:flutter/material.dart';

class OTPController extends GetxController {
  ResetPassController? resetController;
  OTPController(this.resetController);
  final OtpFieldController otpController = OtpFieldController();
  final CountdownController timeController = CountdownController(autoStart: true);

  @override
  void onInit() async {
    _verifyUrl = (await RemoteServices.sendRegisterOtp())!;
    super.onInit();
  }

  bool _isTimeUp = false;
  bool get isTimeUp => _isTimeUp;
  void toggleTimerState(bool val) {
    _isTimeUp = val;
    update();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void toggleLoadingOtp(bool value) {
    _isLoading = value;
    update();
  }

  late String _verifyUrl;

  void resendOtp() async {
    if (!_isTimeUp) return;
    toggleLoadingOtp(true);

    if (resetController == null) {
      _verifyUrl = (await RemoteServices.sendRegisterOtp())!;
    } else {
      await RemoteServices.sendForgotPasswordOtp(resetController!.email.text);
    }
    timeController.restart();
    otpController.clear();
    _isTimeUp = false;

    toggleLoadingOtp(false);
  }

  void verifyOtp(String pin) async {
    if (_isTimeUp) {
      Get.defaultDialog(middleText: "انتهت صلاحية الرمز, اطلب رمزأً جديداً");
      return;
    }
    toggleLoadingOtp(true);

    if (resetController == null) {
      if (await RemoteServices.verifyRegisterOtp(_verifyUrl, pin)) {
        Get.back();
      }
      //else {
      //   Get.defaultDialog(
      //     titleStyle: const TextStyle(color: Colors.black),
      //     middleTextStyle: const TextStyle(color: Colors.black),
      //     backgroundColor: Colors.white,
      //     middleText: "رمز التحقق خاطئ",
      //   );
      // }
    } else {
      String? resetToken = await RemoteServices.verifyForgotPasswordOtp(resetController!.email.text, pin);
      if (resetToken == null) {
        Get.defaultDialog(
          titleStyle: const TextStyle(color: Colors.black),
          middleTextStyle: const TextStyle(color: Colors.black),
          backgroundColor: Colors.white,
          middleText: "رمز التحقق خاطئ",
        );
        return;
      }
      resetController!.setResetToken(resetToken);
      Get.off(() => const ResetPasswordView2());
    }
    toggleLoadingOtp(false);
  }
}
