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

  Future<void> getLocation(context) async {
    ColorScheme cs = Theme.of(context).colorScheme;
    toggleLoading(true);
    LocationPermission permission;

    if (!await Geolocator.isLocationServiceEnabled()) {
      toggleLoading(false);
      Get.defaultDialog(
        title: "",
        content: Column(
          children: [
            const Icon(
              Icons.location_on,
              size: 80,
            ),
            Text(
              "من فضلك قم بتشغيل خدمة تحديد الموقع أولأ",
              style: TextStyle(fontSize: 24, color: cs.onSurface),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        toggleLoading(false);
        Get.showSnackbar(const GetSnackBar(
          message: "تم رفض صلاحية الموقع, لا يمكن تحديد موقعك الحالي",
          duration: Duration(milliseconds: 1500),
        ));
      }
    }

    if (permission == LocationPermission.deniedForever) {
      toggleLoading(false);
      Get.showSnackbar(const GetSnackBar(
        message: "تم رفض صلاحية الموقع, يجب اعطاء صلاحية من اعدادات التطبيق",
        duration: Duration(milliseconds: 1500),
      ));
    }
    try {
      position = await Geolocator.getCurrentPosition();
    } catch (e) {
      print(e.toString());
      //Get.defaultDialog(middleText: e.toString());
    }
    print('${position!.longitude} ${position!.latitude}');
    Get.defaultDialog(middleText: '${position!.longitude} ${position!.latitude}');
    toggleLoading(false);
  }

  Future<void> submit() async {
    buttonPressed = true;
    bool isValid = dataFormKey.currentState!.validate();
    if (position == null) {
      Get.showSnackbar(const GetSnackBar(
        message: "خذ الاحداثيات اولأ",
        duration: Duration(milliseconds: 1500),
      ));
    }
    if (!isValid) return;
    //
  }
}
