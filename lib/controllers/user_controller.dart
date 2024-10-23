import 'dart:async';

import 'package:get/get.dart';
import 'package:lelia/models/report_model.dart';
import 'package:lelia/models/user_model.dart';

import '../constants.dart';
import '../services/remote_services.dart';

class UserController extends GetxController {
  late UserModel user;
  UserController({required this.user});

  @override
  void onInit() {
    if (user.role == "مندوب مبيعات") getReports();
    super.onInit();
  }

  List<ReportModel> reports = [];

  bool _isLoadingReports = false;
  bool get isLoadingReports => _isLoadingReports;
  void toggleLoadingReports(bool value) {
    _isLoadingReports = value;
    update();
  }

  void getReports() async {
    try {
      toggleLoadingReports(true);
      reports.addAll((await RemoteServices.fetchSubordinateReports(user.id).timeout(kTimeOutDuration))!);
    } on TimeoutException {
      kTimeOutDialog();
    } catch (e) {
      print(e.toString());
    } finally {
      toggleLoadingReports(false);
    }
  }
}
