import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../constants.dart';
import '../models/user_model.dart';
import '../services/remote_services.dart';
import '../views/login_view.dart';
import 'login_controller.dart';

class SupervisorController extends GetxController {
  final GetStorage _getStorage = GetStorage();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void toggleLoading(bool value) {
    _isLoading = value;
    update();
  }

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  void getCurrentUser() async {
    try {
      toggleLoading(true);
      _currentUser = (await RemoteServices.fetchCurrentUser().timeout(kTimeOutDuration))!;
      print(_currentUser);
    } on TimeoutException {
      kTimeOutDialog();
    } catch (e) {
      print(e.toString());
    } finally {
      toggleLoading(false);
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
