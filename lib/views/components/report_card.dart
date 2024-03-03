import 'package:flutter/material.dart';
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
        title: Text(report.title),
        subtitle: Text(report.date.toIso8601String()),
        trailing: report.uploaded! ? Icon(Icons.upload, color: Colors.green) : Icon(Icons.sd_storage));
  }
}
