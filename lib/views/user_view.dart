import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lelia/controllers/local_reports_controller.dart';
import 'package:lelia/models/report_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../constants.dart';
import '../controllers/report_controller.dart';
import '../models/user_model.dart';
import 'map_page.dart';

class UserView extends StatelessWidget {
  final UserModel user;
  final bool? supervisor;
  const UserView({super.key, required this.user, this.supervisor});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: cs.background,
      appBar: AppBar(
        title: Text(
          "ملف المندوب",
          style: tt.headlineSmall!.copyWith(color: cs.onPrimary),
        ),
        actions: [
          //
        ],
        backgroundColor: cs.primary,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, color: cs.onPrimary),
        ),
      ),
      body: Scrollbar(
        thumbVisibility: true,
        child: ListView(
          padding: const EdgeInsets.only(top: 12, bottom: 16, right: 8, left: 8),
          children: [
            Padding(
              padding: const EdgeInsets.all(4),
              child: DottedBorder(
                color: cs.onSurface,
                dashPattern: const [1, 0],
                strokeWidth: 2.0,
                borderType: BorderType.RRect,
                radius: const Radius.circular(10),
                padding: const EdgeInsets.only(right: 8, left: 4, top: 4, bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            user.userName,
                            style: tt.titleSmall!.copyWith(color: cs.onSurface),
                            maxLines: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            user.email,
                            style: tt.titleSmall!.copyWith(color: cs.onSurface),
                            maxLines: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            user.phone,
                            style: tt.titleSmall!.copyWith(color: cs.onSurface),
                            maxLines: 1,
                          ),
                        ),
                        //todo fetch real date
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "انضم في ${Jiffy.parseFromDateTime(DateTime.now()).format(pattern: "d / M / y")}",
                            style: tt.titleSmall!.copyWith(color: cs.onSurface),
                            maxLines: 1,
                          ),
                        ),
                        //todo fetch is_activated
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                          child: Text(
                            user.isVerified ? "تم تفعيل حسابه من الشركة" : "الحساب غير مفعل من الشركة",
                            style: tt.titleSmall!.copyWith(color: user.isVerified ? Colors.green : Colors.red),
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(
                          Icons.person,
                          size: 130,
                          color: cs.onSurface,
                        ),
                        Text(
                          user.role,
                          style: tt.titleSmall!.copyWith(color: cs.onSurface),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
