import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lelia/controllers/register_controller.dart';
import 'package:lelia/models/user_model.dart';
import 'package:lelia/views/components/auth_dropdown.dart';
import 'package:lelia/views/components/auth_field.dart';
import 'package:lelia/views/components/custom_dropdown.dart';

import 'components/custom_field.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    RegisterController rC = Get.put(RegisterController());
    return SafeArea(
      child: Scaffold(
        backgroundColor: cs.background,
        body: SingleChildScrollView(
          child: Form(
            key: rC.registerFormKey,
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
                    'ادخل بياناتك للتسجيل:',
                    style: tt.titleLarge!.copyWith(color: cs.onBackground),
                  ),
                ),
                AuthField(
                  label: "اسم المستخدم",
                  controller: rC.userName,
                  keyboardType: TextInputType.text,
                  prefixIcon: Icon(Icons.person_outline),
                  validator: (val) {
                    return validateInput(rC.userName.text, 4, 50, "name");
                  },
                  onChanged: (val) {
                    if (rC.buttonPressed) rC.registerFormKey.currentState!.validate();
                  },
                ),
                const SizedBox(height: 8),
                AuthField(
                  label: "البريد الإلكتروني",
                  controller: rC.email,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icon(Icons.email_outlined),
                  validator: (val) {
                    return validateInput(rC.email.text, 4, 50, "email");
                  },
                  onChanged: (val) {
                    if (rC.buttonPressed) rC.registerFormKey.currentState!.validate();
                  },
                ),
                const SizedBox(height: 8),
                AuthField(
                  label: "موبايل",
                  controller: rC.phone,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icon(Icons.phone_android),
                  validator: (val) {
                    return validateInput(rC.phone.text, 10, 10, "phone");
                  },
                  onChanged: (val) {
                    if (rC.buttonPressed) rC.registerFormKey.currentState!.validate();
                  },
                ),
                const SizedBox(height: 8),
                GetBuilder<RegisterController>(
                  builder: (con) => AuthField(
                    controller: con.password,
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
                      return validateInput(rC.password.text, 8, 50, "password");
                    },
                    onChanged: (val) {
                      if (con.buttonPressed) con.registerFormKey.currentState!.validate();
                    },
                  ),
                ),
                const SizedBox(height: 8),
                GetBuilder<RegisterController>(
                  builder: (con) => AuthField(
                    controller: con.rePassword,
                    keyboardType: TextInputType.text,
                    obscure: !con.rePasswordVisible,
                    label: "تأكيد كلمة المرور",
                    prefixIcon: Icon(CupertinoIcons.lock),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        con.toggleRePasswordVisibility(!con.rePasswordVisible);
                      },
                      child: Icon(con.rePasswordVisible ? CupertinoIcons.eye_slash : CupertinoIcons.eye),
                    ),
                    validator: (val) {
                      return validateInput(
                        rC.rePassword.text,
                        4,
                        50,
                        "password",
                        pass: rC.password.text,
                        rePass: rC.rePassword.text,
                      );
                    },
                    onChanged: (val) {
                      if (con.buttonPressed) con.registerFormKey.currentState!.validate();
                    },
                  ),
                ),
                const SizedBox(height: 8),
                GetBuilder<RegisterController>(builder: (con) {
                  return AuthDropdown(
                    icon: Icons.work_outline,
                    title: "الدور",
                    items: ["مندوب مبيعات", "مشرف"],
                    onSelect: (String? newVal) {
                      con.setRole(newVal!);
                    },
                    selectedValue: con.selectedRole,
                  );
                }),
                GetBuilder<RegisterController>(builder: (con) {
                  return Visibility(
                    visible: con.roleINEnglish == "salesman",
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                      child: DropdownSearch<UserModel>(
                        validator: (user) {
                          if (user == null && con.roleINEnglish == "salesman") return "الرجاء اختيار مشرف";
                          return null;
                        },
                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          searchFieldProps: TextFieldProps(
                            decoration: InputDecoration(
                              fillColor: Colors.white70,
                              hintText: "اسم المشرف",
                              prefix: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Icon(Icons.search, color: cs.onSurface),
                              ),
                            ),
                          ),
                        ),
                        decoratorProps: DropDownDecoratorProps(
                          decoration: InputDecoration(
                            labelText: "المشرف".tr,
                            labelStyle: tt.titleMedium!.copyWith(color: cs.onBackground),
                            hintText: "اختر اسم المشرف".tr,
                            icon: Icon(
                              Icons.supervisor_account_outlined,
                              color: cs.onBackground,
                            ),
                          ),
                        ),
                        items: (filter, infiniteScrollProps) => con.availableSupervisors,
                        itemAsString: (UserModel user) => user.userName,
                        onChanged: (UserModel? user) async {
                          con.setSupervisor(user!);
                          await Future.delayed(Duration(milliseconds: 1000));
                          if (con.buttonPressed) con.registerFormKey.currentState!.validate();
                        },
                        //enabled: !con.enabled,
                      ),
                    ),
                  );
                }),
                GetBuilder<RegisterController>(
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
                            ? CircularProgressIndicator(color: cs.onPrimary)
                            : Padding(
                                padding: const EdgeInsets.all(4),
                                child: Text(
                                  "تسجيل",
                                  style: tt.titleMedium!.copyWith(color: cs.onPrimary),
                                ),
                              ),
                      ),
                      onTap: () {
                        con.register();
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
