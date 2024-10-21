import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  /// if possible, add url launcher for the phone an email. and add website when ready.
  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cs.primary,
        title: Text(
          'حول التطبيق',
          style: tt.headlineMedium!.copyWith(color: cs.onPrimary),
        ),
        centerTitle: true,
      ),
      body: ListView(
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              "تم تطوير هذا البرنامج لصالح شركة ليتيا المساهمة الخاصة, جميع الحقوق محفوظة.",
              style: tt.titleMedium!.copyWith(color: cs.onSurface),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12, left: 12, top: 28, bottom: 12),
            child: Text(
              "للتواصل مع المطور",
              style: tt.titleMedium!.copyWith(color: cs.onSurface),
            ),
          ),
          ListTile(
            leading: Icon(Icons.phone_android, color: cs.primary),
            title: Text(
              "موبايل",
              style: tt.titleMedium!.copyWith(color: cs.onSurface),
            ),
            subtitle: Text(
              "0964622616",
              style: tt.titleMedium!.copyWith(color: cs.onSurface.withOpacity(0.8)),
            ),
          ),
          ListTile(
            leading: Icon(Icons.email, color: cs.primary),
            title: Text(
              "بريد الكتروني",
              style: tt.titleMedium!.copyWith(color: cs.onSurface),
            ),
            subtitle: Text(
              "abdMohsen333@gmail.com",
              style: tt.titleMedium!.copyWith(color: cs.onSurface.withOpacity(0.8)),
            ),
          ),
          //todo: put company contact info if necessary
        ],
      ),
    );
  }
}
