import 'package:get_storage/get_storage.dart';
import 'package:lelia/models/report_model.dart';

class LocalServices {
  static final GetStorage _local = GetStorage();

  static List<ReportModel> loadReports() {
    List<ReportModel> reports = [];
    if (_local.hasData("reports")) {
      reports.addAll(reportModelFromJsonLocal(_local.read("reports")));
    }
    return reports;
  }

  static void storeReport(ReportModel report) {
    List<ReportModel> reports = loadReports();
    reports.add(report);
    _local.write("reports", reportModelToJson(reports));
  }

  static void storeReports(List<ReportModel> reports) {
    _local.write("reports", reportModelToJson(reports));
  }
}
