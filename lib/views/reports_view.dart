import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lelia/controllers/reports_controller.dart';
import 'package:lelia/views/components/report_card.dart';

class ReportsView extends StatelessWidget {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "التقارير المحفوظة",
            style: tt.headlineMedium!.copyWith(color: cs.onPrimary),
          ),
          bottom: TabBar(
            indicatorColor: Colors.deepOrange,
            indicatorWeight: 4,
            tabs: [
              Tab(
                icon: Icon(
                  Icons.save,
                  color: cs.onPrimary,
                  size: 27,
                ),
                child: Text("غير مرفوع".tr, style: tt.titleMedium!.copyWith(color: cs.onPrimary)),
              ),
              Tab(
                icon: Icon(
                  Icons.cloud_upload_outlined,
                  color: cs.onPrimary,
                  size: 27,
                ),
                child: Text("مرفوع".tr, style: tt.titleMedium!.copyWith(color: cs.onPrimary)),
              ),
            ],
          ),
          backgroundColor: cs.primary,
        ),
        body: GetBuilder<ReportsController>(
            init: ReportsController(),
            builder: (con) {
              return TabBarView(
                children: [
                  ListView.builder(
                    itemCount: con.reports.where((report) => report.uploaded!).length,
                    itemBuilder: (context, i) => ReportCard(report: con.reports[i]),
                  ),
                  ListView.builder(
                    itemCount: con.reports.where((report) => !report.uploaded!).length,
                    itemBuilder: (context, i) => ReportCard(report: con.reports[i]),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
