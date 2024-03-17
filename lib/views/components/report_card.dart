import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lelia/controllers/reports_controller.dart';
import 'package:lelia/models/report_model.dart';

class ReportCard extends StatelessWidget {
  final ReportModel report;
  const ReportCard({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    ReportsController rC = Get.find();
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    return ListTile(
      leading: Icon(Icons.edit_calendar_outlined),
      title: Text(
        report.title,
        style: tt.titleLarge!.copyWith(color: cs.onBackground),
      ),
      subtitle: Text(
        "${Jiffy(report.date).format("d/M/y")}  ${Jiffy(report.date).jms}",
        //" ${report.date.hour}:${report.date.minute}",
        style: tt.labelLarge!.copyWith(color: cs.onBackground),
      ),
      trailing: report.uploaded! ? Icon(Icons.upload, color: Colors.green) : Icon(Icons.sd_storage),
      onTap: () {
        Get.dialog(AlertDialog(
          icon: Icon(
            Icons.checklist_rtl_outlined,
            color: cs.primary,
            size: 35,
          ),
          actions: [
            TextButton(
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
                      style: tt.titleLarge!.copyWith(color: Colors.red),
                    ),
                  ),
                  cancel: TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      "لا",
                      style: tt.titleLarge!.copyWith(color: cs.primary),
                    ),
                  ),
                );
              },
              child: Text(
                "حذف",
                style: tt.titleMedium?.copyWith(color: Colors.red),
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
                        ReportField(title: "اسم النقطة", value: report.title),
                        ReportField(title: "نوع النقطة", value: report.type),
                        ReportField(title: "حجم النقطة", value: report.size),
                        ReportField(title: "اسم الحي", value: report.neighborhood),
                        ReportField(title: "اسم الشارع", value: report.street),
                        ReportField(title: "رقم ارضي", value: report.landline),
                        ReportField(title: "رقم موبايل", value: report.mobile),
                        ReportField(title: "حركة المنتج", value: report.availability ? report.status! : "غير متواجد"),
                        ReportField(title: "ملاحظات الزبون", value: report.notes),
                        // todo: add map to see location
                        // todo: edit?
                        // todo: slider to view images (with image view package)
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
          style: tt.titleLarge!.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
          maxLines: 5,
        ),
        subtitle: Text(
          value,
          style: tt.titleMedium!.copyWith(color: cs.onSurface),
        ),
      ),
    );
  }
}
