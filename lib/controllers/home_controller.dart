import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

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
  Position? position;
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

  Future<void> getLocation() async {
    toggleLoading(true);
    LocationPermission permission;

    // Test if location services are enabled.
    if (!await Geolocator.isLocationServiceEnabled()) {
      toggleLoading(false);
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        toggleLoading(false);
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      toggleLoading(false);
      return Future.error('Location permissions are permanently denied');
    }
    position = await Geolocator.getCurrentPosition();
    print('${position!.latitude} ${position!.longitude}');
    Get.defaultDialog(middleText: '${position!.latitude} ${position!.longitude}');
    toggleLoading(false);
  }

  Future<void> submit() async {
    buttonPressed = true;
    bool isValid = dataFormKey.currentState!.validate();
    if (!isValid) return;
    // show a dialog
    //
  }
}
