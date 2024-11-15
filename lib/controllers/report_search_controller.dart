import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lelia/models/report_model.dart';
import 'package:lelia/services/remote_services.dart';

import '../services/screen_service.dart';

class ReportSearchController extends GetxController {
  @override
  void onInit() {
    limit = (screenService.screenHeightCm / 1.1).toInt();
    print("limit: " + limit.toString()); //might be 0 sometimes
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        search(false);
      }
    });
    super.onInit();
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
    _debounce?.cancel();
    super.onClose();
  }

  final screenService = Get.find<ScreenService>();

  ScrollController scrollController = ScrollController();

  final TextEditingController query = TextEditingController();

  final List<ReportModel> _searchResult = [];
  List<ReportModel> get searchResult => _searchResult;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void toggleLoading(bool value) {
    _isLoading = value;
    update();
  }

  int page = 1, limit = 5;
  bool hasMore = true;
  bool failed = false;
  Timer? _debounce;

  void performSearch() async {
    // Cancel the previous timer if it exists
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    // Start a new timer
    _debounce = Timer(const Duration(seconds: 1), () async {
      search(true);
    });
  }

  void search(bool queryChanged) async {
    if (isLoading || (!queryChanged && !hasMore)) return;
    if (queryChanged) {
      _searchResult.clear();
      page = 1;
      hasMore = true;
      failed = false;
    }
    if (query.text.trim().isEmpty) {
      update();
      return;
    }
    toggleLoading(true);
    List<ReportModel>? res = await RemoteServices.fetchSearchReports(page, limit, query.text);
    if (res == null) {
      failed = true;
    } else {
      failed = false;
      if (res.length < limit) hasMore = false;
      _searchResult.addAll(res);
      page++;
    }
    toggleLoading(false);
  }
}
