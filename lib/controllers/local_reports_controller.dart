import 'package:get/get.dart';
import 'package:lelia/models/report_model.dart';
import 'package:lelia/services/local_services.dart';
import 'package:lelia/services/remote_services.dart';

class LocalReportsController extends GetxController {
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

  Future<void> uploadReport(ReportModel report) async {
    if (await RemoteServices.uploadReport(report)) {
      report.uploaded = true;
      LocalServices.storeReports(reports);
      update();
    } else {
      print("error when uploading");
    }
  }
}
