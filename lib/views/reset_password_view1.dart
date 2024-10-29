import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lelia/controllers/reset_password_controller.dart';

import 'components/auth_field.dart';
import 'components/custom_field.dart';

///to enter the email for the account you want to reset its password
class ResetPasswordView1 extends StatelessWidget {
  const ResetPasswordView1({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    ResetPassController fC = Get.put(ResetPassController());
    return Scaffold(
      backgroundColor: cs.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
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
                        height: MediaQuery.sizeOf(context).width / 1.8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "ادخل بريدك الإلكتروني لاعادة تعييين كلمة المرور الخاصة بحسابك:",
                    style: tt.titleMedium!.copyWith(color: cs.onBackground),
                  ),
                ),
                const SizedBox(height: 30),
                Form(
                  key: fC.firstFormKey,
                  child: AuthField(
                    label: "البريد الإلكتروني",
                    controller: fC.email,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email_outlined),
                    validator: (val) {
                      return validateInput(fC.email.text, 4, 50, "email");
                    },
                    onChanged: (val) {
                      if (fC.button1Pressed) fC.firstFormKey.currentState!.validate();
                    },
                  ),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: GetBuilder<ResetPassController>(
                    builder: (con) => Center(
                      child: GestureDetector(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: cs.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: con.isLoading1
                              ? SizedBox(width: 60, child: SpinKitThreeBounce(color: cs.onPrimary, size: 24))
                              : Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Text(
                                    "التالي",
                                    style: tt.titleMedium!.copyWith(color: cs.onPrimary),
                                  ),
                                ),
                        ),
                        onTap: () {
                          con.toOTP();
                        },
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
    );
  }
}
