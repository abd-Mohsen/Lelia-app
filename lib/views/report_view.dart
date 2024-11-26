import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lelia/controllers/local_reports_controller.dart';
import 'package:lelia/models/report_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../constants.dart';
import '../controllers/report_controller.dart';
import 'map_page.dart';

class ReportView extends StatelessWidget {
  final ReportModel report;
  final bool local;
  final bool? supervisor;
  const ReportView({super.key, required this.report, required this.local, this.supervisor});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    late LocalReportsController lRC;
    if (local) lRC = Get.find();

    return Scaffold(
      backgroundColor: cs.background,
      appBar: AppBar(
        title: Text(
          "تقرير",
          style: tt.headlineSmall!.copyWith(color: cs.onPrimary),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(
                MapPage(latitude: report.latitude, longitude: report.longitude),
              );
            },
            icon: Icon(Icons.location_pin, color: cs.onPrimary),
          ),
          Visibility(
            visible: local,
            child: IconButton(
              onPressed: () {
                Get.defaultDialog(
                  title: "",
                  content: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "هل تريد حذف هذا التقرير؟${(!report.uploaded!) ? "\n لم يتم رفع التقرير بعد" : ""}",
                      style: tt.headlineSmall!.copyWith(color: cs.onSurface),
                    ),
                  ),
                  confirm: TextButton(
                    onPressed: () {
                      Get.back();
                      Get.back();
                      lRC.deleteReport(report);
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
              icon: Icon(Icons.delete, color: cs.error),
            ),
          ),
        ],
        backgroundColor: cs.primary,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, color: cs.onPrimary),
        ),
      ),
      floatingActionButton: !report.uploaded!
          ? FloatingActionButton(
              onPressed: () => lRC.uploadReport(report),
              child: GetBuilder<LocalReportsController>(builder: (con) {
                return con.isLoading
                    ? SpinKitChasingDots(color: cs.onPrimary, size: 25)
                    : Icon(
                        Icons.upload,
                        color: cs.onPrimary,
                      );
              }),
            )
          : null,
      body: Scrollbar(
        thumbVisibility: true,
        child: ListView(
          padding: const EdgeInsets.only(top: 12, bottom: 16, right: 8, left: 8),
          children: [
            if (supervisor ?? false) ReportField(title: "اسم المندوب", value: report.owner!.userName),
            ReportField(title: "اسم النقطة", value: report.title),
            ReportField(title: "نوع النقطة", value: report.type),
            ReportField(title: "حجم النقطة", value: report.size),
            ReportField(title: "اسم الحي", value: report.neighborhood),
            ReportField(title: "اسم الشارع", value: report.street),
            ReportField(title: "رقم ارضي", value: report.landline),
            ReportField(title: "رقم موبايل", value: report.mobile),
            ReportField(
              title: "التاريخ",
              value: "${Jiffy.parseFromDateTime(report.date).E} "
                  "${Jiffy.parseFromDateTime(report.date).format(pattern: "d/M/y")}",
            ),
            ReportField(title: "الساعة", value: "${Jiffy.parseFromDateTime(report.date).jms}"),
            ReportField(title: "حركة المنتج", value: report.status ?? "غير متواجد"),
            ReportField(title: "ملاحظات الزبون", value: report.notes ?? ""),
            report.images.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: cs.onSurface,
                      size: 100,
                    ),
                  )
                : GetBuilder<ReportController>(
                    init: ReportController(),
                    builder: (con) {
                      return SizedBox(
                        width: 300,
                        height: 400,
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
                                                          headers: const {"Keep-Alive": "timeout=5, max=1000"},

                                                          /// add loading
                                                          // loadingBuilder: (context, child, loadingProgress) {
                                                          //   return const Center(
                                                          //     child: CircularProgressIndicator(),
                                                          //   );
                                                          // },
                                                        ),
                                                ),
                                              ),
                                            );
                                          },
                                          child: local
                                              ? Image.file(File(image))
                                              : Image.network(
                                                  "$kHostIP/${Uri.encodeComponent(image)}",
                                                  headers: const {"Keep-Alive": "timeout=5, max=1000"},
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
                    },
                  ),
          ],
        ),
      ),
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
      padding: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          radius: 5,
          backgroundColor: cs.onBackground.withOpacity(0.7),
        ),
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
