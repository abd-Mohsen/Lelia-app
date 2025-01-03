import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lelia/models/report_model.dart';
import 'package:lelia/models/user_model.dart';

import '../main.dart';
import '../services/remote_services.dart';

class UserController extends GetxController {
  late UserModel user;
  UserController({required this.user});

  @override
  void onInit() {
    limit = (screenService.screenHeightCm).toInt() - 4;
    print(limit);
    if (user.role == "مندوب مبيعات") getReports();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (!failed) getReports();
      }
    });
    super.onInit();
  }

  ScrollController scrollController = ScrollController();

  int page = 1, limit = 7;
  bool hasMore = true;
  bool failed = false;

  List<ReportModel> reports = [];

  bool _isLoadingReports = false;
  bool get isLoadingReports => _isLoadingReports;
  void toggleLoadingReports(bool value) {
    _isLoadingReports = value;
    update();
  }

  void getReports() async {
    if (isLoadingReports || !hasMore) return;
    failed = false;
    update();
    if (page == 1) toggleLoadingReports(true);

    List<ReportModel>? newReports = await RemoteServices.fetchSubordinateReports(user.id, page, limit);
    if (newReports == null) {
      failed = true;
    } else {
      if (newReports.length < limit) hasMore = false;
      reports.addAll(newReports);
      page++;
    }
    toggleLoadingReports(false);
  }

  Future<void> refreshReports() async {
    page = 1;
    hasMore = true;
    reports.clear();
    getReports();
  }
}
