import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lelia/controllers/locale_controller.dart';
import 'package:lelia/controllers/theme_controller.dart';
import 'package:lelia/services/screen_service.dart';
import 'package:lelia/themes.dart';
import 'package:lelia/views/redirect_page.dart';

import 'locale.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => ScreenService().init());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ThemeController t = Get.put(ThemeController());
    LocaleController l = LocaleController();
    return GetMaterialApp(
      translations: MyLocale(),
      locale: l.initialLang,
      title: 'lelia',
      home: const RedirectPage(),
      theme: MyThemes.myLightMode, //custom light theme
      darkTheme: MyThemes.myDarkMode, //custom dark theme
      themeMode: t.getThemeMode(),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return MediaQuery(
          ///to make text factor 1 for all text widgets (user cant fuck it up from phone settings)
          data: MediaQuery.of(context).copyWith(devicePixelRatio: 1, textScaler: const TextScaler.linear(1)),
          child: child!,
        );
      },
    );
  }
}
