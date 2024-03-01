import 'package:get/get.dart';
import 'package:flutter/material.dart';

class HomeController extends GetxController {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void toggleLoading(bool value) {
    _isLoading = value;
    update();
  }

  GlobalKey<FormState> dataFormKey = GlobalKey<FormState>();
  bool buttonPressed = false;

  TextEditingController name = TextEditingController();
  // can it be a dropdown
  String type = "بقالية";
  String size = "صغير";
  TextEditingController neighborhood = TextEditingController();
  TextEditingController street = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController mobilePhone = TextEditingController();
  String status = "بطيئة"; // حركة المنتج
  TextEditingController notes = TextEditingController();
  // todo : store the date in model
  // todo: store 'if uploaded' in model

  bool _available = false; // hide status if no
  bool get available => _available;

  void toggleAvailability(bool val) {
    _available = val;
    update();
  }

  void setType(String type) {
    this.type = type;
    update();
  }

  void setSize(String size) {
    this.size = size;
    update();
  }

  void setStatus(String status) {
    this.status = status;
    update();
  }

  Future<void> submit() async {
    buttonPressed = true;
    bool isValid = dataFormKey.currentState!.validate();
    if (!isValid) return;
    // show a dialog
    //
  }
}
