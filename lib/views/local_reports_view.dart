import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lelia/controllers/home_controller.dart';
import 'package:lelia/controllers/local_reports_controller.dart';
import 'package:lelia/models/report_model.dart';
import 'package:lelia/views/components/report_card.dart';

class LocalReportsView extends StatelessWidget {
  const LocalReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    HomeController hC = Get.find();
    LocalReportsController lRC = Get.put(LocalReportsController(homeController: hC));

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: cs.background,
        appBar: AppBar(
          title: Text(
            "التقارير المحفوظة",
            style: tt.headlineSmall!.copyWith(color: cs.onPrimary),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Get.defaultDialog(
                  title: "",
                  content: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "هل تريد حذف جميع التقارير المحفوظة؟ ستخسر جميع التقارير الغير مرفوعة",
                      style: tt.headlineSmall!.copyWith(color: cs.onSurface),
                    ),
                  ),
                  confirm: TextButton(
                    onPressed: () {
                      Get.defaultDialog(
                        title: "",
                        content: Text(
                          "متأكد؟",
                          style: tt.headlineSmall!.copyWith(color: cs.onSurface),
                        ),
                        confirm: TextButton(
                          onPressed: () {
                            lRC.clearReports();
                            Get.back();
                            Get.back();
                          },
                          child: Text(
                            "نعم",
                            style: tt.titleMedium!.copyWith(color: Colors.red),
                          ),
                        ),
                        cancel: TextButton(
                          onPressed: () {
                            Get.back();
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
            IconButton(
              onPressed: () {
                lRC.exportReports();
              },
              icon: Icon(Icons.print, color: cs.onPrimary),
            ),
          ],
          bottom: TabBar(
            indicatorColor: Colors.deepOrange,
            indicatorWeight: 4,
            tabs: [
              Tab(
                icon: Icon(
                  Icons.save,
                  color: cs.onPrimary,
                  size: 25,
                ),
                child: Text("غير مرسل".tr, style: tt.bodyLarge!.copyWith(color: cs.onPrimary)),
              ),
              Tab(
                icon: Icon(
                  Icons.cloud_upload_outlined,
                  color: cs.onPrimary,
                  size: 25,
                ),
                child: Text("مرسل".tr, style: tt.bodyLarge!.copyWith(color: cs.onPrimary)),
              ),
            ],
          ),
          backgroundColor: cs.primary,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back, color: cs.onPrimary),
          ),
        ),
        body: GetBuilder<LocalReportsController>(
            //init: ReportsController(),
            builder: (con) {
          List<ReportModel> uploaded = con.reports.where((report) => !report.uploaded!).toList();
          List<ReportModel> notUploaded = con.reports.where((report) => report.uploaded!).toList();
          return TabBarView(
            children: [
              ListView.builder(
                itemCount: uploaded.length,
                itemBuilder: (context, i) => ReportCard(
                  report: uploaded[i],
                  local: true,
                ),
              ),
              ListView.builder(
                itemCount: notUploaded.length,
                itemBuilder: (context, i) => ReportCard(
                  report: notUploaded[i],
                  local: true,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
