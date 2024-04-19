import 'dart:async';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:lelia/views/home_view.dart';

import '../constants.dart';

class LoginController extends GetxController {
  @override
  void onClose() {
    // email.dispose();
    // password.dispose();
    super.onClose();
  }

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
        //String? accessToken = await RemoteServices.signUserIn(name.text, password.text).timeout(kTimeOutDuration);
        //if (accessToken == null) throw Exception();
        //_getStorage.write("token", accessToken); // todo: repeat this for all pages we have issues with
        Get.offAll(() => const HomeView());
        //dispose();
      } on TimeoutException {
        kTimeOutDialog();
      } catch (e) {
        //print(e.toString());
      } finally {
        toggleLoading(false);
      }
    }
  }
//"eve.holt@reqres.in"
}
