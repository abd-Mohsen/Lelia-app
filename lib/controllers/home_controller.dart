import 'dart:async';
import 'package:image/image.dart' as img;

import 'package:get_storage/get_storage.dart';
import 'package:lelia/models/user_model.dart';
import 'package:lelia/services/remote_services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lelia/controllers/login_controller.dart';
import 'package:lelia/models/report_model.dart';
import 'package:lelia/services/local_services.dart';
import 'package:lelia/views/login_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../constants.dart';

class HomeController extends GetxController {
  @override
  onInit() {
    getCurrentUser();
    super.onInit();
  }

  final GetStorage _getStorage = GetStorage();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void toggleLoading(bool value) {
    _isLoading = value;
    update();
  }

  bool _isLoadingUser = false;
  bool get isLoadingUser => _isLoadingUser;
  void toggleLoadingUser(bool value) {
    _isLoadingUser = value;
    update();
  }

  bool _isLoadingSubmit = false;
  bool get isLoadingSubmit => _isLoadingSubmit;
  void toggleLoadingSubmit(bool value) {
    _isLoadingSubmit = value;
    update();
  }

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  void getCurrentUser() async {
    toggleLoadingUser(true);
    _currentUser = await RemoteServices.fetchCurrentUser();
    if (_currentUser != null && !_currentUser!.isActivated) {
      Get.dialog(kActivateAccountDialog(), barrierDismissible: false);
    }
    toggleLoadingUser(false);
  }

  GlobalKey<FormState> dataFormKey = GlobalKey<FormState>();
  bool buttonPressed = false;

  TextEditingController name = TextEditingController();
  String type = "بقالية";
  String size = "صغير";
  TextEditingController neighborhood = TextEditingController();
  TextEditingController street = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController mobilePhone = TextEditingController();
  String state = "بطيئة";
  TextEditingController notes = TextEditingController();
  Position? position;

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

  void setReportState(String state) {
    this.state = state;
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
    dataFormKey.currentState!.reset(); // remove errors
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
    toggleLoadingSubmit(false);
  }

  List<XFile> images = [];

  Future pickImage(String source) async {
    if (source == "camera") {
      XFile? selectedImage = await ImagePicker().pickImage(source: ImageSource.camera);
      if (selectedImage != null) images.add(selectedImage);
    } else {
      List<XFile> selectedImages = await ImagePicker().pickMultiImage();
      if (selectedImages.isNotEmpty) images.addAll(selectedImages);
    }
    update();
    Get.back();
  }

  int _picIndex = 0;
  int get picIndex => _picIndex;
  void setPicIndex(int i) {
    _picIndex = i;
    update();
  }

  void removeImage(XFile image) {
    images.remove(image);
    update();
  }

  Future<File> compressImage(XFile file) async {
    File originalFile = File(file.path);

    final bytes = await originalFile.readAsBytes();
    img.Image? originalImage = img.decodeImage(bytes);

    int quality = 100;
    int maxSize = 2 * 1024 * 1024; // 2 MB in bytes
    List<int> compressedBytes;

    do {
      // Encode the image with the current quality
      compressedBytes = img.encodeJpg(originalImage!, quality: quality);
      quality -= 20;
    } while (compressedBytes.length > maxSize && quality > 0);

    File compressedFile = File('${originalFile.parent.path}/compressed_${originalFile.uri.pathSegments.last}');
    await compressedFile.writeAsBytes(compressedBytes);

    return compressedFile;
  }

  Future<void> submit() async {
    if (_isLoadingSubmit) return;
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
    if (position == null) {
      Get.showSnackbar(const GetSnackBar(
        message: "خذ الاحداثيات اولأ",
        duration: Duration(milliseconds: 1500),
      ));
      return;
    }
    toggleLoadingSubmit(true);
    // save images in app dir
    Directory appDir = await getApplicationDocumentsDirectory();
    List<String> storedImagesPaths = [];

    for (XFile image in images) {
      //compress images (find another way, this might not be working properly)
      String imagePath = path.join(appDir.path, path.basename(image.path));
      File file = await compressImage(image);
      await file.copy(imagePath);
      storedImagesPaths.add(imagePath);
    }
    ReportModel report = ReportModel(
      title: name.text,
      type: type,
      size: size,
      neighborhood: neighborhood.text,
      street: street.text,
      mobile: mobilePhone.text,
      landline: phone.text,
      availability: available,
      status: available ? state : null,
      notes: notes.text,
      longitude: position!.longitude,
      latitude: position!.latitude,
      date: DateTime.now(),
      uploaded: false,
      images: storedImagesPaths,
    );
    LocalServices.storeReport(report);
    toggleLoadingSubmit(false);
    Get.showSnackbar(const GetSnackBar(
      message: "تم التخزين بنجاح",
      duration: Duration(milliseconds: 2500),
    ));
  }

  void logout() async {
    //console is printing that login controller is deleted when i enter the login page
    //iam getting socket exception instead of 401 (this might be because of wrong host)
    if (await RemoteServices.logout()) {
      _getStorage.remove("token");
      _getStorage.remove("role");
      Get.put(LoginController());
      Get.offAll(() => const LoginView());
    }
  }
}
