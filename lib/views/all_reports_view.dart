import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lelia/controllers/all_reports_controller.dart';
import 'package:lelia/views/components/report_card.dart';

import '../models/report_model.dart';

class AllReportsView extends StatelessWidget {
  const AllReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    //AllReportsController aRC = Get.put(AllReportsController());

    return Scaffold(
      backgroundColor: cs.background,
      appBar: AppBar(
        title: Text(
          "التقارير المرسلة",
          style: tt.headlineSmall!.copyWith(color: cs.onPrimary),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.defaultDialog(
                titleStyle: const TextStyle(color: Colors.black),
                middleTextStyle: const TextStyle(color: Colors.black),
                backgroundColor: Colors.white,
                title: "ملاحظة",
                middleText: "هنا يمكنك فقط رؤية التقارير التي تم رفعها",
              );
            },
            icon: Icon(Icons.info_outline, color: cs.onPrimary),
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
      body: GetBuilder<AllReportsController>(
        init: AllReportsController(),
        builder: (con) {
          List<ReportModel> allReports = con.reports;
          return con.isLoading
              ? Center(child: SpinKitCubeGrid(color: cs.primary))
              : RefreshIndicator(
                  onRefresh: con.refreshReports,
                  child: allReports.isEmpty
                      ? ListView(
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  'لا يوجد تقارير بعد, أو هناك مشكلة اتصال\n اسحب للتحديث',
                                  style: tt.titleMedium!.copyWith(color: cs.onSurface),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          controller: con.scrollController,
                          itemCount: allReports.length + 1,
                          itemBuilder: (context, i) {
                            if (i < allReports.length) {
                              return ReportCard(
                                report: allReports[i],
                                local: false,
                                supervisor: true,
                              );
                            }
                            // Show loading indicator or end-of-list indication
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 24),
                                child: con.failed
                                    ? ElevatedButton(
                                        onPressed: () {
                                          con.getReports();
                                        },
                                        style: ButtonStyle(
                                          backgroundColor: WidgetStateProperty.all<Color>(cs.primary),
                                        ),
                                        child: Text(
                                          'خطأ, انقر للتحديث',
                                          style: tt.titleMedium!.copyWith(color: cs.onPrimary),
                                        ),
                                      )
                                    : con.hasMore
                                        ? CircularProgressIndicator(color: cs.primary)
                                        : CircleAvatar(
                                            radius: 5,
                                            backgroundColor: Colors.grey.withOpacity(0.7),
                                          ),
                              ),
                            );
                          },
                        ),
                );
        },
      ),
    );
  }
}
