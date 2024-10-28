import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lelia/models/report_model.dart';
import 'package:lelia/models/user_model.dart';

import '../constants.dart';
import '../services/remote_services.dart';
import '../services/screen_service.dart';

class UserController extends GetxController {
  late UserModel user;
  UserController({required this.user});

  @override
  void onInit() {
    limit = (screenService.screenHeightCm).toInt() - 4;
    if (user.role == "مندوب مبيعات") getReports();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        getReports();
      }
    });
    super.onInit();
  }

  final screenService = Get.find<ScreenService>();

  ScrollController scrollController = ScrollController();

  int page = 1, limit = 7;
  bool hasMore = true;

  List<ReportModel> reports = [];

  bool _isLoadingReports = false;
  bool get isLoadingReports => _isLoadingReports;
  void toggleLoadingReports(bool value) {
    _isLoadingReports = value;
    update();
  }

  void getReports() async {
    if (isLoadingReports || !hasMore) return;
    if (page == 1) toggleLoadingReports(true);
    try {
      List<ReportModel> newReports =
          await RemoteServices.fetchSubordinateReports(user.id, page, limit).timeout(kTimeOutDuration) ?? [];
      if (newReports.length < limit) hasMore = false;
      reports.addAll(newReports);
    } on TimeoutException {
      kTimeOutDialog();
    } catch (e) {
      print(e.toString());
    } finally {
      toggleLoadingReports(false);
    }
    page++;
  }

  Future<void> refreshReports() async {
    page = 1;
    hasMore = true;
    reports.clear();
    getReports();
  }
}
