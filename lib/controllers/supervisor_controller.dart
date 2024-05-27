import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../constants.dart';
import '../models/report_model.dart';
import '../models/user_model.dart';
import '../services/remote_services.dart';
import '../views/login_view.dart';
import 'login_controller.dart';

class SupervisorController extends GetxController {
  @override
  void onInit() {
    getCurrentUser();
    getReports();
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
