import 'dart:async';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lelia/views/home_view.dart';

import '../constants.dart';
import '../services/remote_services.dart';

class LoginController extends GetxController {
  @override
  void onClose() {
    // email.dispose();
    // password.dispose();
    super.onClose();
  }

  final GetStorage _getStorage = GetStorage();

  final email = TextEditingController();
  final password = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  bool buttonPressed = false;

  void toggleLoading(bool value) {
    _isLoading = value;
    update();
  }

  bool _passwordVisible = false;
  bool get passwordVisible => _passwordVisible;
  void togglePasswordVisibility(bool value) {
    _passwordVisible = value;
    update();
  }

  void login() async {
    buttonPressed = true;
    bool isValid = loginFormKey.currentState!.validate();
    if (isValid) {
      toggleLoading(true);
      try {
        String? accessToken = await RemoteServices.login(email.text, password.text).timeout(kTimeOutDuration);
        if (accessToken == null) return;
        _getStorage.write("token", accessToken);
        print(_getStorage.read("token"));
        //todo: handle role (go to another home if supervisor, make a login model)
        // await Future.delayed(Duration(milliseconds: 800));
        Get.offAll(() => const HomeView());
        //dispose();
      } on TimeoutException {
        kTimeOutDialog();
      } catch (e) {
        print(e.toString());
      } finally {
        toggleLoading(false);
      }
    }
  }
}
