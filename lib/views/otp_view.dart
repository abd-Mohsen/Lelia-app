import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lelia/controllers/otp_controller.dart';
import 'package:lelia/controllers/reset_password_controller.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:get/get.dart';
import 'package:timer_count_down/timer_count_down.dart';

class OTPView extends StatelessWidget {
  final String source;
  const OTPView({super.key, required this.source});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    late ResetPassController rPC;
    if (source == "reset") rPC = Get.find();
    OTPController oC = Get.put(OTPController(source == "reset" ? rPC : null));
    return SafeArea(
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) {
            return;
          }
          //Get.dialog(kCloseAppDialog());
        },
        child: Scaffold(
          backgroundColor: cs.background,
          body: Center(
            child: ListView(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: GetBuilder<OTPController>(
                    //init: OTPController(),
                    builder: (con) => Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          !con.isTimeUp ? "صالح حتى" : "انتهت صلاحية الرمز الحالي",
                          style: tt.titleLarge!.copyWith(color: con.isTimeUp ? Colors.red : cs.onBackground),
                        ),
                        const SizedBox(height: 8),
                        Countdown(
                          controller: con.timeController,
                          seconds: 180,
                          build: (_, double time) => Text(
                            time.toString(),
                            style: tt.titleLarge!.copyWith(color: con.isTimeUp ? Colors.red : cs.onBackground),
                          ),
                          onFinished: () {
                            con.toggleTimerState(true);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Hero(
                    tag: "logo",
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          "assets/images/lelia_logo.jpg",
                          height: MediaQuery.sizeOf(context).width / 2.5,
                        ),
                      ),
                    ),
                  ),
                ),
                if (source == "register")
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    child: Text(
                      'يجب تأكيد بريدك الالكتروني قبل استخدام التطبيق, اذا استخدمت بريد الكتروني خاطئ للتسجيل قم بانشاء'
                      ' حساب جديد مع بريد الكتروني صحيح',
                      style: tt.titleSmall!.copyWith(color: cs.onBackground),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Text(
                    'من فضلك ادخل الرمز الذي ارسلناه الى بريدك الالكتروني:',
                    style: tt.titleMedium!.copyWith(color: cs.onBackground),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 60, left: 12, right: 12),
                  child: GetBuilder<OTPController>(
                    builder: (con) => Directionality(
                      textDirection: TextDirection.ltr,
                      child: OTPTextField(
                        //todo(later): let app focus on the first need when resending and when opening page
                        controller: con.otpController,
                        otpFieldStyle: OtpFieldStyle(
                          focusBorderColor: cs.primary,
                          backgroundColor: Colors.grey.shade200,
                        ),
                        hasError: con.isTimeUp,
                        outlineBorderRadius: 15,
                        length: 5,
                        width: MediaQuery.of(context).size.width / 1.2,
                        fieldWidth: MediaQuery.of(context).size.width / 8,
                        style: tt.labelLarge!.copyWith(color: Colors.black),
                        textFieldAlignment: MainAxisAlignment.spaceAround,
                        fieldStyle: FieldStyle.box,
                        onCompleted: (pin) {
                          con.verifyOtp(pin);
                        },
                        onChanged: (val) {},
                      ),
                    ),
                  ),
                ),
                GetBuilder<OTPController>(
                  builder: (con) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                    child: GestureDetector(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: !con.isTimeUp ? Colors.grey : cs.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: con.isLoading
                              ? SpinKitThreeBounce(
                                  color: cs.onPrimary,
                                  size: 28,
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Text(
                                    "اعد ارسال الرمز",
                                    style: tt.titleMedium!.copyWith(color: cs.onPrimary),
                                  ),
                                ),
                        ),
                      ),
                      onTap: () {
                        con.resendOtp();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
