import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lelia/controllers/login_controller.dart';
import 'package:lelia/models/report_model.dart';
import 'package:lelia/services/local_services.dart';
import 'package:lelia/views/login_view.dart';

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
              "من فضلك قم بتشغيل خدمة تحديد الموقع أولاً",
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
    //Get.defaultDialog(middleText: '${position!.longitude} ${position!.latitude}');
    toggleLoading(false);
  }

  void clearReport() {
    name.text = "";
    neighborhood.text = "";
    street.text = "";
    phone.text = "";
    mobilePhone.text = "";
    notes.text = "";
    buttonPressed = false;
    _available = false;
    position = null;
    images.clear();
    update();
  }

  List<XFile> images = [];

  Future pickImage() async {
    List<XFile> selectedImages = await ImagePicker().pickMultiImage();
    if (selectedImages.isNotEmpty) images.addAll(selectedImages);
    update();
  }

  int _picIndex = 0;
  int get picIndex => _picIndex;
  void setPicIndex(int i) {
    _picIndex = i;
    update();
  }

  // Future<void> pickImage() async {
  //   XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (image != null) {
  //     newImg = await image.readAsBytes();
  //     isNewImgSelected = true;
  //     update();
  //   }
  // }

  Future<void> submit() async {
    buttonPressed = true;
    bool isValid = dataFormKey.currentState!.validate();
    if (position == null) {
      Get.showSnackbar(const GetSnackBar(
        message: "خذ الاحداثيات اولأ",
        duration: Duration(milliseconds: 1500),
      ));
      return;
    }
    if (!isValid) return;
    ReportModel report = ReportModel(
      title: name.text,
      type: type,
      size: size,
      neighborhood: neighborhood.text,
      street: street.text,
      mobile: mobilePhone.text,
      landline: phone.text,
      availability: available,
      status: available ? status : null,
      notes: notes.text,
      longitude: position!.longitude,
      latitude: position!.latitude,
      date: DateTime.now(),
      uploaded: false,
    );
    LocalServices.storeReport(report);
    Get.showSnackbar(const GetSnackBar(
      message: "تم التخزين بنجاح",
      duration: Duration(milliseconds: 1500),
    ));
  }

  void logout() {
    Get.put(LoginController());
    Get.offAll(() => const LoginView());
  }
}
