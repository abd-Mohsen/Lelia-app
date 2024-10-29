import 'dart:async';
import 'package:get/get.dart';
import 'package:lelia/controllers/reset_password_controller.dart';
import 'package:lelia/views/home_view.dart';
import 'package:lelia/views/login_view.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:timer_count_down/timer_controller.dart';
import '../constants.dart';
import '../services/remote_services.dart';
import '../views/reset_password_view2.dart';

class OTPController extends GetxController {
  ResetPassController? resetController;
  OTPController(this.resetController);
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

  void resendOtp() async {
    if (!_isTimeUp) return;
    toggleLoadingOtp(true);
    try {
      if (resetController == null) {
        _verifyUrl = (await RemoteServices.sendRegisterOtp().timeout(kTimeOutDuration))!;
      } else {
        await RemoteServices.sendForgotPasswordOtp(resetController!.email.text).timeout(kTimeOutDuration);
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

  void verifyOtp(String pin) async {
    if (_isTimeUp) {
      Get.defaultDialog(middleText: "انتهت صلاحية الرمز, اطلب رمزأً جديداً");
      return;
    }
    toggleLoadingOtp(true);
    try {
      if (resetController == null) {
        if (await RemoteServices.verifyRegisterOtp(_verifyUrl, pin).timeout(kTimeOutDuration)) {
          Get.offAll(() => const HomeView());
          Get.defaultDialog(middleText: "تم تأكيد بريدك الالكتروني بنجاح");
        } else {
          Get.defaultDialog(middleText: "رمز التحقق خاطئ");
        }
      } else {
        String? resetToken =
            (await RemoteServices.verifyForgotPasswordOtp(resetController!.email.text, pin).timeout(kTimeOutDuration));
        if (resetToken == null) {
          Get.defaultDialog(middleText: "رمز التحقق خاطئ");
          return;
        }
        resetController!.setResetToken(resetToken);
        Get.off(() => const ResetPasswordView2());
      }
    } on TimeoutException {
      kTimeOutDialog();
    } catch (e) {
      //print(e.toString());
    } finally {
      toggleLoadingOtp(false);
    }
  }
}
