import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lelia/controllers/reset_password_controller.dart';
import 'components/auth_field.dart';
import 'components/custom_field.dart';

///if otp is correct , set a new password for the account with the email entered earlier
class ForgotPasswordView2 extends StatelessWidget {
  const ForgotPasswordView2({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    ResetPassController rPC = Get.find();
    return Scaffold(
      backgroundColor: cs.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: rPC.secondFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  Hero(
                    tag: "logo",
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          "assets/images/lelia_logo.jpg",
                          height: MediaQuery.sizeOf(context).width / 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'ادخل كلمة مرور جديدة',
                    style: tt.titleMedium!.copyWith(color: Get.isDarkMode ? cs.onBackground : Colors.grey[700]),
                  ),
                  const SizedBox(height: 25),
                  GetBuilder<ResetPassController>(
                    builder: (con) => AuthField(
                      controller: con.newPassword,
                      keyboardType: TextInputType.text,
                      obscure: !con.passwordVisible,
                      label: "كلمة المرور الجديدة",
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          con.togglePasswordVisibility(!con.passwordVisible);
                        },
                        child: Icon(con.passwordVisible ? CupertinoIcons.eye_slash : CupertinoIcons.eye),
                      ),
                      validator: (val) {
                        return validateInput(con.newPassword.text, 8, 50, "password");
                      },
                      onChanged: (val) {
                        if (con.button2Pressed) con.secondFormKey.currentState!.validate();
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  GetBuilder<ResetPassController>(
                    builder: (con) => AuthField(
                      controller: con.rePassword,
                      keyboardType: TextInputType.text,
                      obscure: !con.rePasswordVisible,
                      label: "تأكيد كلمة المرور",
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          con.toggleRePasswordVisibility(!con.rePasswordVisible);
                        },
                        child: Icon(con.rePasswordVisible ? CupertinoIcons.eye_slash : CupertinoIcons.eye),
                      ),
                      validator: (val) {
                        return validateInput(
                          con.rePassword.text,
                          8,
                          50,
                          "password",
                          pass: con.newPassword.text,
                          rePass: con.rePassword.text,
                        );
                      },
                      onChanged: (val) {
                        if (con.button2Pressed) con.secondFormKey.currentState!.validate();
                      },
                    ),
                  ),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: GetBuilder<ResetPassController>(
                      builder: (con) => GestureDetector(
                        onTap: () {
                          rPC.resetPass();
                          //hideKeyboard(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: cs.primary,
                          ),
                          margin: EdgeInsets.all(8),
                          padding: EdgeInsets.all(12),
                          child: rPC.isLoading2
                              ? SpinKitThreeBounce(color: cs.onPrimary, size: 24)
                              : Text(
                                  "موافق",
                                  style: tt.titleMedium!.copyWith(color: cs.onPrimary),
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
