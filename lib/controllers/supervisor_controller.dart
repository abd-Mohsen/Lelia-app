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
