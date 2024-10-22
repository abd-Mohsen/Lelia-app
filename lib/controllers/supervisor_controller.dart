import 'dart:async';
import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jiffy/jiffy.dart';
import 'package:path/path.dart';
import '../constants.dart';
import '../models/report_model.dart';
import '../models/user_model.dart';
import '../services/remote_services.dart';
import '../views/login_view.dart';
import 'login_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

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

  bool _isLoadingExport = false;
  bool get isLoadingExport => _isLoadingExport;
  void toggleLoadingExport(bool value) {
    _isLoadingExport = value;
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

  final List<ReportModel> _exportedReports = [];
  List<ReportModel> get exportedReports => _exportedReports;

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

  Future<void> refreshReports() async {
    toggleLoadingReports(true);
    reports.clear();
    getReports();
  }

  Future<void> refreshSubordinates() async {
    toggleLoadingSubs(true);
    subordinates.clear();
    getSubordinates();
  }

  Future<void> getExportReports() async {
    try {
      toggleLoadingExport(true);
      _exportedReports.addAll((await RemoteServices.fetchExportedReports(
        fromDate!.toIso8601String(),
        toDate!.toIso8601String(),
        selectedSubordinate?.id,
      ).timeout(kTimeOutDuration))!);
    } on TimeoutException {
      kTimeOutDialog();
    } catch (e) {
      print(e.toString());
    } finally {
      toggleLoadingExport(false);
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

  TextEditingController fileName = TextEditingController();

  String generateFor = "كل المندوبين لدي";
  void setGenerateFor(String val) {
    if (val == "كل المندوبين لدي") selectedSubordinate = null;
    generateFor = val;
    update();
  }

  UserModel? selectedSubordinate;
  void selectSubordinate(UserModel? user) {
    selectedSubordinate = user;
    update();
  }

  DateTime? fromDate;
  void setFromDate(DateTime val) {
    fromDate = val;
    update();
  }

  DateTime? toDate;
  void setToDate(DateTime val) {
    toDate = val;
    update();
  }

  Future<void> export() async {
    buttonPressed = true;
    bool isValid = dataFormKey.currentState!.validate();
    if (!isValid) return;
    if (currentUser == null || fromDate == null || toDate == null) return;

    PermissionStatus status = await Permission.storage.status;
    if (!status.isGranted) {
      PermissionStatus newStatus = await Permission.storage.request();
      if (!newStatus.isGranted) {
        Get.showSnackbar(const GetSnackBar(
          message: "تم رفض اذن التخزين, لا يمكن تصدير الملف",
          duration: Duration(milliseconds: 1500),
        ));
        return;
      }
    }
    await getExportReports();
    var excel = Excel.createExcel();
    Sheet sheet = excel['report'];
    excel.setDefaultSheet('report');
    excel.delete('Sheet1');
    sheet.isRTL = true;

    // Add metadata
    sheet.appendRow([TextCellValue('مشرف'), TextCellValue(currentUser!.userName)]);
    sheet.appendRow(
      [
        TextCellValue('تاريخ'),
        TextCellValue(
          "${Jiffy.parseFromDateTime(DateTime.now()).format(pattern: "d/M/y")}  "
          "${Jiffy.parseFromDateTime(DateTime.now()).jms}",
        ),
      ],
    );
    sheet.appendRow([TextCellValue('المنطقة')]);
    if (generateFor == "مندوب محدد") sheet.appendRow([TextCellValue('مندوب')]);
    sheet.appendRow([TextCellValue('')]);
    sheet.appendRow([
      TextCellValue('#'),
      TextCellValue('اسم'),
      TextCellValue('نوع'),
      TextCellValue('حجم'),
      TextCellValue('الحي'),
      TextCellValue('الشارع'),
      TextCellValue('موبايل'),
      TextCellValue('أرضي'),
      TextCellValue('تواجد'),
      TextCellValue('حركة المنتج'),
      TextCellValue('ملاحظات الزبون'),
    ]);

    // Add the header row with merged cells
    // sheet.merge(CellIndex.indexByString("A1"), CellIndex.indexByString("A2")); // Merge for "#"
    // sheet.merge(CellIndex.indexByString("B1"), CellIndex.indexByString("B2")); // Merge for "اسم النقطة"
    // sheet.merge(CellIndex.indexByString("C1"), CellIndex.indexByString("C2")); // Merge for "نوع النقطة"
    // sheet.merge(CellIndex.indexByString("D1"), CellIndex.indexByString("D2")); // Merge for "حجم النقطة"
    // sheet.merge(CellIndex.indexByString("E1"), CellIndex.indexByString("G1")); // Merge for "العنوان"
    // sheet.merge(CellIndex.indexByString("H1"), CellIndex.indexByString("I1")); // Merge for "تلفون"
    // sheet.merge(CellIndex.indexByString("J1"), CellIndex.indexByString("J2")); // Merge for "التواجد"
    // sheet.merge(CellIndex.indexByString("K1"), CellIndex.indexByString("K2")); // Merge for "حركة المنتج"
    // sheet.merge(CellIndex.indexByString("L1"), CellIndex.indexByString("L2")); // Merge for ملاحظات الزبون

    // Add the header text
    // sheet.cell(CellIndex.indexByString("A1")).value = TextCellValue("#");
    // sheet.cell(CellIndex.indexByString("B1")).value = TextCellValue("اسم النقطة");
    // sheet.cell(CellIndex.indexByString("C1")).value = TextCellValue("نوع النقطة");
    // sheet.cell(CellIndex.indexByString("D1")).value = TextCellValue("حجم النقطة");
    // sheet.cell(CellIndex.indexByString("E1")).value = TextCellValue("العنوان");
    // sheet.cell(CellIndex.indexByString("E2")).value = TextCellValue("الحي");
    // sheet.cell(CellIndex.indexByString("F2")).value = TextCellValue("الشارع");
    // sheet.cell(CellIndex.indexByString("G2")).value = TextCellValue("موبايل");
    // sheet.cell(CellIndex.indexByString("H1")).value = TextCellValue("تلفون");
    // sheet.cell(CellIndex.indexByString("H2")).value = TextCellValue("موبايل");
    // sheet.cell(CellIndex.indexByString("I2")).value = TextCellValue("ارضي");
    // sheet.cell(CellIndex.indexByString("J1")).value = TextCellValue("التواجد");
    // sheet.cell(CellIndex.indexByString("K1")).value = TextCellValue("حركة المنتج");
    // sheet.cell(CellIndex.indexByString("L1")).value = TextCellValue("ملاحظات الزبون");

    for (int i = 0; i < _exportedReports.length; i++) {
      var report = _exportedReports[i];
      sheet.appendRow([
        TextCellValue((i + 1).toString()),
        TextCellValue(report.title),
        TextCellValue(report.type),
        TextCellValue(report.size),
        TextCellValue(report.neighborhood),
        TextCellValue(report.street),
        TextCellValue(report.mobile),
        TextCellValue(report.landline),
        TextCellValue(report.availability! ? "نعم" : "لا"),
        TextCellValue(report.status ?? ""),
        TextCellValue(report.notes ?? ""),
      ]);
    }

    // Save the Excel file
    List<int>? fileBytes = excel.save();
    //var directory = await DownloadsPathProvider.downloadsDirectory;

    File(join('/storage/emulated/0/Download/${fileName.text}.xlsx')) //choose a suitable path
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes!);
    Get.showSnackbar(const GetSnackBar(
      message: "تم التخزين في مجلد التنزيلات",
      duration: Duration(milliseconds: 2500),
    ));
    //todo: instead of saving, share the file
  }

  GlobalKey<FormState> dataFormKey = GlobalKey<FormState>();
  bool buttonPressed = false;

  void logout() async {
    if (await RemoteServices.logout()) {
      _getStorage.remove("token");
      _getStorage.remove("role");
      Get.put(LoginController());
      Get.offAll(() => const LoginView());
    }
  }
}
