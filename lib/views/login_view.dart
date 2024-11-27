import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lelia/views/components/auth_field.dart';
import 'package:lelia/views/register_view.dart';
import 'package:lelia/views/reset_password_view1.dart';

import '../constants.dart';
import '../controllers/login_controller.dart';
import 'components/custom_field.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    LoginController lC = Get.put(LoginController());
    return WillPopScope(
      onWillPop: () async {
        Get.dialog(kCloseAppDialog());
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: cs.background,
          body: SingleChildScrollView(
            child: Form(
              key: lC.loginFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 36),
                    child: Hero(
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
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
                    child: Text(
                      'ادخل بياناتك للدخول:',
                      style: tt.titleLarge!.copyWith(color: cs.onBackground),
                    ),
                  ),
                  AuthField(
                    label: "البريد الإلكتروني",
                    controller: lC.email,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icon(Icons.email_outlined),
                    validator: (val) {
                      return validateInput(lC.email.text, 4, 50, "email");
                    },
                    onChanged: (val) {
                      if (lC.buttonPressed) lC.loginFormKey.currentState!.validate();
                    },
                  ),
                  const SizedBox(height: 8),
                  GetBuilder<LoginController>(
                    builder: (con) => AuthField(
                      controller: lC.password,
                      keyboardType: TextInputType.text,
                      obscure: !con.passwordVisible,
                      label: "كلمة المرور",
                      prefixIcon: Icon(CupertinoIcons.lock),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          con.togglePasswordVisibility(!con.passwordVisible);
                        },
                        child: Icon(con.passwordVisible ? CupertinoIcons.eye_slash : CupertinoIcons.eye),
                      ),
                      validator: (val) {
                        return validateInput(lC.password.text, 4, 50, "password");
                      },
                      onChanged: (val) {
                        if (con.buttonPressed) con.loginFormKey.currentState!.validate();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextButton(
                      onPressed: () {
                        Get.to(ResetPasswordView1());
                      },
                      child: Text(
                        "نسيت كلمة المرور؟",
                        style: tt.labelLarge!.copyWith(color: cs.onBackground.withOpacity(0.6)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  GetBuilder<LoginController>(
                    builder: (con) => Center(
                      child: GestureDetector(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: cs.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: con.isLoading
                              ? SizedBox(width: 120, child: SpinKitThreeBounce(color: cs.onPrimary, size: 24))
                              : Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Text(
                                    "تسجيل دخول",
                                    style: tt.titleMedium!.copyWith(color: cs.onPrimary),
                                  ),
                                ),
                        ),
                        onTap: () {
                          con.login();
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "لا تملك حساباً؟",
                          style: tt.titleMedium!.copyWith(color: cs.onBackground),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.to(() => const RegisterView());
                          },
                          child: Text(
                            "انقر للتسجيل",
                            style: tt.titleMedium!.copyWith(color: Colors.blueAccent),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
