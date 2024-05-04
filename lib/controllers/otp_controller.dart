import 'dart:async';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:timer_count_down/timer_controller.dart';
import '../constants.dart';
import '../services/remote_services.dart';

class OTPController extends GetxController {
  final OtpFieldController otpController = OtpFieldController();
  final CountdownController timeController = CountdownController(autoStart: true);

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

  void verifyOtp(String pin) async {
    if (_isTimeUp) {
      Get.defaultDialog(middleText: "otp time up dialog".tr);
      return;
    }
    toggleLoadingOtp(true);
    try {
      if (await RemoteServices.verifyRegisterOtp(_verifyUrl, pin).timeout(kTimeOutDuration)) {
        //Get.offAll(() => const LoginPage());
        //Get.defaultDialog(middleText: "account created successfully, please login".tr);
      } else {
        Get.defaultDialog(middleText: "wrong otp dialog".tr);
      }
    } on TimeoutException {
      kTimeOutDialog();
    } catch (e) {
      //print(e.toString());
    } finally {
      toggleLoadingOtp(false);
    }
  }

  void resendOtp(String source) async {
    if (!_isTimeUp) {
      return;
    }
    toggleLoadingOtp(true);
    try {
      if (source == "register") {
        _verifyUrl = (await RemoteServices.sendRegisterOtp().timeout(kTimeOutDuration))!;
      } else {
        //
      }
      timeController.restart();
      otpController.clear();
      _isTimeUp = false;
    } on TimeoutException {
      kTimeOutDialog();
    } catch (e) {
      print(e.toString());
    } finally {
      toggleLoadingOtp(false);
    }
  }

  void verifyOtpReset(String pin, String email) async {
    if (_isTimeUp) {
      Get.defaultDialog(middleText: "otp time up dialog".tr);
    } else {
      toggleLoadingOtp(true);
      try {
        String? resetToken = (await RemoteServices.verifyForgotPasswordOtp(email, pin).timeout(kTimeOutDuration));
        if (resetToken == null) Get.defaultDialog(middleText: "wrong otp dialog".tr);
        //Get.off(() => const ForgotPasswordPage2());
      } on TimeoutException {
        kTimeOutDialog();
      } catch (e) {
        //print(e.toString());
      } finally {
        toggleLoadingOtp(false);
      }
    }
  }
}
