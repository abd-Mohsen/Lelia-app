import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lelia/views/login_view.dart';

String kHostIP = "http://192.168.1.35:8000";
//"http://10.0.2.2:8000";
//"http://lelia-back.000webhostapp.com";

String kFontFamily = 'Alexandria';

Duration kTimeOutDuration = const Duration(seconds: 25);
Duration kTimeOutDuration2 = const Duration(seconds: 15);
Duration kTimeOutDuration3 = const Duration(seconds: 7);

AlertDialog kCloseAppDialog() => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text("هل تريد الخروج من التطبيق؟"),
      actions: [
        TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: Text(
              "نعم",
              //style: kTextStyle20.copyWith(color: Colors.red),
            )),
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              "لا",
              //style: kTextStyle20,
            )),
      ],
    );

AlertDialog kSessionExpiredDialog() => AlertDialog(
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(10),
      // ),
      title: Text("انتهت صلاحية الجلسة"),
      content: Text("من فضلك سجل دخول مرة أخرى"),
      actions: [
        TextButton(
            onPressed: () {
              Get.offAll(() => const LoginView());
            },
            child: Text(
              "ok",
              //style: kTextStyle20.copyWith(color: Colors.red),
            )),
      ],
    );

AlertDialog kAboutAppDialog() => AlertDialog(
      //todo: fix the dialog length, and add contact info for both company and dev
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text(
            "ok",
            //style: tt.titleMedium?.copyWith(color: cs.primary),
          ),
        ),
      ],
      content: Column(
        children: [
          Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "تم تطوير هذا البرنامج لصالح شركة ليتيا المغفلة الخاصة, جميع الحقوق محفوظة",
                      //style: tt.headlineSmall!.copyWith(color: cs.onSurface),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

Future kTimeOutDialog() => Get.defaultDialog(
      title: "فشل الاتصال",
      middleText: "تأكد من اتصالك بالانترنت ثم حاول مجدداً",
    );

TextTheme kMyTextTheme = TextTheme(
  displayLarge: TextStyle(
    fontSize: 57,
    //wordSpacing: 64,
    letterSpacing: 0,
    fontFamily: kFontFamily,
  ),
  displayMedium: TextStyle(
    fontSize: 45,
    //wordSpacing: 52,
    letterSpacing: 0,
    fontFamily: kFontFamily,
  ),
  displaySmall: TextStyle(
    fontSize: 36,
    //wordSpacing: 44,
    letterSpacing: 0,
    fontFamily: kFontFamily,
  ),
  headlineLarge: TextStyle(
    fontSize: 32,
    //wordSpacing: 40,
    letterSpacing: 0,
    fontFamily: kFontFamily,
  ),
  headlineMedium: TextStyle(
    fontSize: 28,
    //wordSpacing: 36,
    letterSpacing: 0,
    fontFamily: kFontFamily,
  ),
  headlineSmall: TextStyle(
    fontSize: 24,
    //wordSpacing: 32,
    letterSpacing: 0,
    fontFamily: kFontFamily,
  ),
  titleLarge: TextStyle(
    fontSize: 22,
    //wordSpacing: 28,
    letterSpacing: 0,
    fontFamily: kFontFamily,
  ),
  titleMedium: TextStyle(
    fontSize: 18,
    //wordSpacing: 24,
    letterSpacing: 0.15,
    fontFamily: kFontFamily,
  ),
  titleSmall: TextStyle(
    fontSize: 14,
    //wordSpacing: 20,
    letterSpacing: 0.1,
    fontFamily: kFontFamily,
  ),
  labelLarge: TextStyle(
    fontSize: 14,
    //wordSpacing: 20,
    letterSpacing: 0.1,
    fontFamily: kFontFamily,
  ),
  labelMedium: TextStyle(
    fontSize: 12,
    //wordSpacing: 16,
    letterSpacing: 0.5,
    fontFamily: kFontFamily,
  ),
  labelSmall: TextStyle(
    fontSize: 11,
    //wordSpacing: 16,
    letterSpacing: 0.5,
    fontFamily: kFontFamily,
  ),
  bodyLarge: TextStyle(
    fontSize: 16,
    //wordSpacing: 24,
    letterSpacing: 0.15,
    fontFamily: kFontFamily,
  ),
  bodyMedium: TextStyle(
    fontSize: 14,
    //wordSpacing: 20,
    letterSpacing: 0.25,
    fontFamily: kFontFamily,
  ),
  bodySmall: TextStyle(
    fontSize: 12,
    //wordSpacing: 16,
    letterSpacing: 0.4,
    fontFamily: kFontFamily,
  ),
);
