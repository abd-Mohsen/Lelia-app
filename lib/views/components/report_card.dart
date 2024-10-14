//import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lelia/constants.dart';
import 'package:lelia/controllers/local_reports_controller.dart';
import 'package:lelia/models/report_model.dart';
import 'dart:io';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../controllers/report_controller.dart';
import '../map_page.dart';

class ReportCard extends StatelessWidget {
  final ReportModel report;
  final bool local;
  final bool? supervisor;
  const ReportCard({super.key, required this.report, required this.local, this.supervisor});

  @override
  Widget build(BuildContext context) {
    late LocalReportsController rC;
    if (local) rC = Get.find();
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    return ListTile(
      leading: Icon(Icons.edit_calendar_outlined),
      title: Text(
        report.title,
        style: tt.titleMedium!.copyWith(color: cs.onBackground),
      ),
      subtitle: Text(
        "${Jiffy.parseFromDateTime(report.date).format(pattern: "d / M / y")}  ${Jiffy.parseFromDateTime(report.date).jms}",
        //" ${report.date.hour}:${report.date.minute}",
        style: tt.labelLarge!.copyWith(color: cs.onBackground),
      ),
      trailing: (supervisor ?? false)
          ? null
          : report.uploaded!
              ? const Icon(Icons.upload, color: Colors.green)
              : const Icon(Icons.sd_storage),
      onTap: () {
        // todo: make a page instead of dialog, and handle all cases, uploaded or not, or the user is a supervisor
        Get.dialog(AlertDialog(
          icon: Icon(
            Icons.checklist_rtl_outlined,
            color: cs.primary,
            size: 35,
          ),
          actions: [
            Visibility(
              visible: local,
              child: TextButton(
                onPressed: () {
                  Get.defaultDialog(
                    title: "",
                    middleText: "هل تريد حذف هذا التقرير؟${(!report.uploaded!) ? "\n لم يتم رفع التقرير بعد" : ""}",
                    middleTextStyle: tt.headlineSmall!.copyWith(color: cs.onSurface),
                    confirm: TextButton(
                      onPressed: () {
                        Get.back();
                        Get.back();
                        rC.deleteReport(report);
                      },
                      child: Text(
                        "نعم",
                        style: tt.titleMedium!.copyWith(color: Colors.red),
                      ),
                    ),
                    cancel: TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        "لا",
                        style: tt.titleMedium!.copyWith(color: cs.primary),
                      ),
                    ),
                  );
                },
                child: Text(
                  "حذف",
                  style: tt.titleMedium?.copyWith(color: Colors.red),
                ),
              ),
            ),
            Visibility(
              visible: !report.uploaded!,
              child: TextButton(
                onPressed: () {
                  rC.uploadReport(report);
                },
                child: Text(
                  "رفع",
                  style: tt.titleMedium?.copyWith(color: cs.primary),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Get.to(
                  MapPage(
                    latitude: report.latitude,
                    longitude: report.longitude,
                  ),
                );
              },
              child: Text(
                "الموقع",
                style: tt.titleMedium?.copyWith(color: cs.primary),
              ),
            ),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                "ok",
                style: tt.titleMedium?.copyWith(color: cs.primary),
              ),
            ),
          ],
          content: Column(
            children: [
              Expanded(
                child: Scrollbar(
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      // todo: why listview not rendering without sized box
                      children: [
                        if (supervisor ?? false) ReportField(title: "اسم المندوب", value: report.owner!.userName),
                        ReportField(title: "اسم النقطة", value: report.title),
                        ReportField(title: "نوع النقطة", value: report.type),
                        ReportField(title: "حجم النقطة", value: report.size),
                        ReportField(title: "اسم الحي", value: report.neighborhood),
                        ReportField(title: "اسم الشارع", value: report.street),
                        ReportField(title: "رقم ارضي", value: report.landline),
                        ReportField(title: "رقم موبايل", value: report.mobile),
                        ReportField(title: "حركة المنتج", value: report.status ?? "غير متواجد"),
                        ReportField(title: "ملاحظات الزبون", value: report.notes ?? ""),
                        GetBuilder<ReportController>(
                            init: ReportController(),
                            builder: (con) {
                              return SizedBox(
                                width: 300,
                                height: 300,
                                child: Column(
                                  children: [
                                    CarouselSlider(
                                      items: [
                                        ...report.images
                                            .map(
                                              (image) => Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Get.dialog(
                                                      AlertDialog(
                                                        title: Text(
                                                          "عرض الصورة",
                                                          style: tt.titleLarge!.copyWith(color: cs.onSurface),
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Get.back();
                                                            },
                                                            child: Text(
                                                              "ok",
                                                              style: tt.titleMedium?.copyWith(color: cs.primary),
                                                            ),
                                                          ),
                                                        ],
                                                        content: InteractiveViewer(
                                                          child: local
                                                              ? Image.file(File(image))
                                                              : Image.network(
                                                                  "$kHostIP/${Uri.encodeComponent(image)}",
                                                                  headers: {"Keep-Alive": "timeout=5, max=1000"},
                                                                ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: local
                                                      ? Image.file(File(image))
                                                      : Image.network(
                                                          "$kHostIP/${Uri.encodeComponent(image)}",
                                                          headers: {"Keep-Alive": "timeout=5, max=1000"},
                                                        ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ],
                                      options: CarouselOptions(
                                        enableInfiniteScroll: false,
                                        aspectRatio: 4 / 4,
                                        onPageChanged: (i, reason) => con.setPicIndex(i),
                                        viewportFraction: 1,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    AnimatedSmoothIndicator(
                                      activeIndex: con.picIndex,
                                      count: report.images.length,
                                      effect: WormEffect(dotHeight: 9, dotWidth: 9, activeDotColor: cs.primary),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
      },
    );
  }
}

class ReportField extends StatelessWidget {
  final String title;
  final String value;

  const ReportField({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(
          title,
          style: tt.titleMedium!.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
          maxLines: 5,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            value,
            style: tt.bodyLarge!.copyWith(color: cs.onSurface),
          ),
        ),
      ),
    );
  }
}
