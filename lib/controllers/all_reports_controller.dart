import 'dart:async';

import 'package:get/get.dart';

import '../constants.dart';
import '../models/report_model.dart';
import '../services/remote_services.dart';

class AllReportsController extends GetxController {
  @override
  void onInit() {
    getReports();
    super.onInit();
  }

  final List<ReportModel> _reports = [];
  List<ReportModel> get reports => _reports;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void toggleLoading(bool value) {
    _isLoading = value;
    update();
  }

  void getReports() async {
    try {
      toggleLoading(true);
      _reports.addAll((await RemoteServices.fetchSalesmanReports().timeout(kTimeOutDuration))!);
    } on TimeoutException {
      kTimeOutDialog();
    } catch (e) {
      print(e.toString());
    } finally {
      toggleLoading(false);
    }
  }
}
