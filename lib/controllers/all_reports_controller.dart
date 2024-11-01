import 'dart:async';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
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
        getReports();
      }
    });
    super.onInit();
  }

  final screenService = Get.find<ScreenService>();

  ScrollController scrollController = ScrollController();

  int page = 1, limit = 4;
  bool hasMore = true;
  //todo: add flag that tells you if the fetch has failed, to show a button and load more

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
    if (page == 1) toggleLoading(true);
    try {
      List<ReportModel> newReports =
          await RemoteServices.fetchSalesmanReports(page, limit).timeout(kTimeOutDuration) ?? [];
      if (newReports.length < limit) hasMore = false;
      _reports.addAll(newReports);
    } on TimeoutException {
      kTimeOutDialog();
    } catch (e) {
      print(e.toString());
    } finally {
      toggleLoading(false);
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
