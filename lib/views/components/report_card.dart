import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lelia/models/report_model.dart';

class ReportCard extends StatelessWidget {
  final ReportModel report;
  const ReportCard({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    return ListTile(
      leading: Icon(Icons.edit_calendar_outlined),
      title: Text(
        report.title,
        style: tt.titleLarge!.copyWith(color: cs.onBackground),
      ),
      subtitle: Text(
        "${Jiffy(report.date).format("d/M/y")}  ${Jiffy(report.date).jm}",
        //" ${report.date.hour}:${report.date.minute}",
        style: tt.labelLarge!.copyWith(color: cs.onBackground),
      ),
      trailing: report.uploaded! ? Icon(Icons.upload, color: Colors.green) : Icon(Icons.sd_storage),
      onTap: () {
        Get.dialog(AlertDialog(
          icon: Icon(
            Icons.pending_actions,
            color: cs.onBackground,
          ),
          title: Text(
            report.title,
            style: tt.titleMedium!.copyWith(color: cs.onSurface),
          ),
          content: Column(
            children: [
              SizedBox(
                height: 500,
                width: 700,
                child: ListView(
                  // todo: why listview not rendering without sized box
                  children: [
                    Text(
                      report.type,
                    ),
                    //todo: read report from here, and add option to delete (and edit?)
                  ],
                ),
              ),
            ],
          ),
        ));
      },
    );
  }
}
