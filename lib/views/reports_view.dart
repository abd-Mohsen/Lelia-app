import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lelia/controllers/reports_controller.dart';
import 'package:lelia/models/report_model.dart';
import 'package:lelia/views/components/report_card.dart';

class ReportsView extends StatelessWidget {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    ReportsController rC = Get.put(ReportsController());

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
                rC.clearReports();
              },
              icon: Icon(Icons.delete, color: cs.onPrimary),
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
                child: Text("غير مرفوع".tr, style: tt.bodyLarge!.copyWith(color: cs.onPrimary)),
              ),
              Tab(
                icon: Icon(
                  Icons.cloud_upload_outlined,
                  color: cs.onPrimary,
                  size: 25,
                ),
                child: Text("مرفوع".tr, style: tt.bodyLarge!.copyWith(color: cs.onPrimary)),
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
        body: GetBuilder<ReportsController>(
            //init: ReportsController(),
            builder: (con) {
          List<ReportModel> uploaded = con.reports.where((report) => !report.uploaded!).toList();
          List<ReportModel> notUploaded = con.reports.where((report) => report.uploaded!).toList();
          return TabBarView(
            children: [
              ListView.builder(
                itemCount: uploaded.length,
                itemBuilder: (context, i) => ReportCard(report: uploaded[i]),
              ),
              ListView.builder(
                itemCount: notUploaded.length,
                itemBuilder: (context, i) => ReportCard(report: notUploaded[i]),
              ),
            ],
          );
        }),
      ),
    );
  }
}
