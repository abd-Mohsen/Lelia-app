import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
          backgroundColor: Get.isDarkMode ? cs.background : Colors.grey[300],
          body: Center(
            child: SingleChildScrollView(
              child: Form(
                key: lC.loginFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    Hero(
                      tag: "logo",
                      child: Icon(Icons.security, size: 80),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'من فضلك ادخل بياناتك للدخول',
                      style: tt.headlineSmall!.copyWith(color: cs.onBackground),
                    ),
                    const SizedBox(height: 25),
                    //
                    const SizedBox(height: 10),
                    GetBuilder<LoginController>(
                      builder: (con) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: lC.password,
                          keyboardType: TextInputType.text,
                          obscureText: !con.passwordVisible,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            //hintText: "password".tr,
                            label: Text("كلمة المرور"),
                            prefixIcon: Icon(Icons.lock_outline),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                con.togglePasswordVisibility(!con.passwordVisible);
                              },
                              child: Icon(con.passwordVisible ? CupertinoIcons.eye_slash : CupertinoIcons.eye),
                            ),
                          ),
                          validator: (val) {
                            return validateInput(lC.password.text, 4, 50, "password");
                          },
                          onChanged: (val) {
                            if (con.buttonPressed) con.loginFormKey.currentState!.validate();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    GetBuilder<LoginController>(
                      builder: (con) => GestureDetector(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: cs.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: con.isLoading
                              ? CircularProgressIndicator(color: cs.onPrimary)
                              : Text(
                                  "تسجيل دخول",
                                  style: tt.titleMedium!.copyWith(color: cs.onPrimary),
                                ),
                        ),
                        onTap: () {
                          con.login();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
