import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lelia/controllers/all_reports_controller.dart';
import 'package:lelia/views/components/report_card.dart';

class AllReportsView extends StatelessWidget {
  const AllReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    //AllReportsController aRC = Get.put(AllReportsController());

    //todo: pagination
    //todo: Connection reset by peer, add a sign to know if not fetched
    //todo: refresh indicator
    // search
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
              //todo: show a dialog "here you can see all the reports you submitted(local reports wont be shown here)"
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
            if (con.isLoading) {
              return Center(
                  child: SpinKitFoldingCube(
                color: cs.primary,
                size: 80,
              ));
            }
            //todo: show network error icon if not fetched
            return ListView.builder(
              itemCount: con.reports.length,
              itemBuilder: (context, i) => ReportCard(
                report: con.reports[i],
                local: false,
              ),
            );
          }),
    );
  }
}
