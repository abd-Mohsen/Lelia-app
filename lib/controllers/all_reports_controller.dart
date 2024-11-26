import 'dart:async';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/report_model.dart';
import '../services/remote_services.dart';
import '../services/screen_service.dart';

class AllReportsController extends GetxController {
  @override
  void onInit() {
    limit = (screenService.screenHeightCm).toInt();
    getReports();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (!failed) getReports();
      }
    });
    super.onInit();
  }

  final screenService = Get.find<ScreenService>();

  ScrollController scrollController = ScrollController();

  int page = 1, limit = 4;
  bool hasMore = true;
  bool failed = false;

  final List<ReportModel> _reports = [];
  List<ReportModel> get reports => _reports;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void toggleLoading(bool value) {
    _isLoading = value;
    update();
  }

  void getReports() async {
    if (isLoading || !hasMore) return;
    failed = false;
    update();
    if (page == 1) toggleLoading(true);

    List<ReportModel>? newReports = await RemoteServices.fetchSalesmanReports(page, limit);
    if (newReports == null) {
      failed = true;
    } else {
      if (newReports.length < limit) hasMore = false;
      _reports.addAll(newReports);
      page++;
    }
    toggleLoading(false);
  }

  Future<void> refreshReports() async {
    page = 1;
    hasMore = true;
    failed = false;
    reports.clear();
    getReports();
  }
}
