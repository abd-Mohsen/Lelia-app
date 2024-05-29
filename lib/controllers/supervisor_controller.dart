import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../constants.dart';
import '../models/report_model.dart';
import '../models/user_model.dart';
import '../services/remote_services.dart';
import '../views/login_view.dart';
import 'login_controller.dart';
import 'package:permission_handler/permission_handler.dart';

class SupervisorController extends GetxController {
  @override
  void onInit() {
    getCurrentUser();
    getReports();
    getSubordinates();
    super.onInit();
  }

  final GetStorage _getStorage = GetStorage();

  bool _isLoadingUser = false;
  bool get isLoadingUser => _isLoadingUser;
  void toggleLoadingUser(bool value) {
    _isLoadingUser = value;
    update();
  }

  bool _isLoadingReports = false;
  bool get isLoadingReports => _isLoadingReports;
  void toggleLoadingReports(bool value) {
    _isLoadingReports = value;
    update();
  }

  bool _isLoadingSubs = false;
  bool get isLoadingSubs => _isLoadingSubs;
  void toggleLoadingSubs(bool value) {
    _isLoadingSubs = value;
    update();
  }

  bool _isLoadingExport = false;
  bool get isLoadingExport => _isLoadingExport;
  void toggleLoadingExport(bool value) {
    _isLoadingExport = value;
    update();
  }

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  void getCurrentUser() async {
    try {
      toggleLoadingUser(true);
      _currentUser = (await RemoteServices.fetchCurrentUser().timeout(kTimeOutDuration))!;
      print(_currentUser);
    } on TimeoutException {
      kTimeOutDialog();
    } catch (e) {
      print(e.toString());
    } finally {
      toggleLoadingUser(false);
    }
  }

  final List<ReportModel> _reports = [];
  List<ReportModel> get reports => _reports;

  void getReports() async {
    try {
      toggleLoadingReports(true);
      _reports.addAll((await RemoteServices.fetchSupervisorReports().timeout(kTimeOutDuration))!);
    } on TimeoutException {
      kTimeOutDialog();
    } catch (e) {
      print(e.toString());
    } finally {
      toggleLoadingReports(false);
    }
  }

  final List<UserModel> _subordinates = [];
  List<UserModel> get subordinates => _subordinates;

  void getSubordinates() async {
    try {
      toggleLoadingSubs(true);
      _subordinates.addAll((await RemoteServices.fetchSupervisorSubordinates().timeout(kTimeOutDuration))!);
    } on TimeoutException {
      kTimeOutDialog();
    } catch (e) {
      print(e.toString());
    } finally {
      toggleLoadingSubs(false);
    }
  }

  TextEditingController fileName = TextEditingController();
  // drop down button to select a certain subordinate or select all
  // select the duration

  Future<void> export() async {
    PermissionStatus status = await Permission.storage.status;
    if (!status.isGranted) {
      PermissionStatus newStatus = await Permission.storage.request();
      if (!newStatus.isGranted) {
        Get.showSnackbar(const GetSnackBar(
          message: "تم رفض اذن التخزين, لا يمكن التخزين",
          duration: Duration(milliseconds: 1500),
        ));
        return;
      }
    }
    buttonPressed = true;
    bool isValid = dataFormKey.currentState!.validate();
    if (!isValid) return;
  }

  GlobalKey<FormState> dataFormKey = GlobalKey<FormState>();
  bool buttonPressed = false;

  void logout() async {
    //todo: console is printing that login controller is deleted when i enter the login page
    if (await RemoteServices.logout()) {
      _getStorage.remove("token");
      _getStorage.remove("role");
      Get.put(LoginController());
      Get.offAll(() => const LoginView());
    }
  }
}
