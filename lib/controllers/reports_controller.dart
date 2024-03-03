import 'package:get/get.dart';
import 'package:lelia/models/report_model.dart';
import 'package:lelia/services/local_services.dart';

class ReportsController extends GetxController {
  @override
  void onInit() {
    reports = LocalServices.loadReports();
    print(reports);
    super.onInit();
  }

  List<ReportModel> reports = [];

  void deleteReport(ReportModel report) {
    // only if its not uploaded
    reports.remove(report);
    LocalServices.storeReports(reports);
    update();
  }

  void clearReports() {
    // todo: show a message first
    reports.clear();
    LocalServices.storeReports(reports);
    update();
  }
}
