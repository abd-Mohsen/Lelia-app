//import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lelia/constants.dart';
import 'package:lelia/controllers/local_reports_controller.dart';
import 'package:lelia/models/report_model.dart';
import 'package:lelia/views/report_view.dart';
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
    late LocalReportsController lRC;
    if (local) lRC = Get.find();
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    return ListTile(
      leading: const Icon(Icons.edit_calendar_outlined),
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
        Get.to(
          ReportView(report: report, local: local, supervisor: supervisor),
        );
      },
    );
  }
}
