import 'dart:io';

import 'package:excel/excel.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lelia/controllers/home_controller.dart';
import 'package:lelia/models/report_model.dart';
import 'package:lelia/services/local_services.dart';
import 'package:lelia/services/remote_services.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';

class LocalReportsController extends GetxController {
  late HomeController homeController;
  LocalReportsController({required this.homeController});

  @override
  void onInit() {
    reports = LocalServices.loadReports();
    print(reports);
    super.onInit();
  }

  List<ReportModel> reports = [];

  void deleteReport(ReportModel report) {
    // only if its not uploaded
    reports.remove(report);
    LocalServices.storeReports(reports);
    update();
  }

  void clearReports() {
    // todo: show a message first
    reports.clear();
    LocalServices.storeReports(reports);
    update();
  }

  Future<void> exportReports() async {
    if (homeController.currentUser == null) return;
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
    var excel = Excel.createExcel();
    Sheet sheet = excel['report'];
    excel.setDefaultSheet('report');
    excel.delete('Sheet1');
    sheet.isRTL = true;

    // Add metadata
    sheet.appendRow([TextCellValue('مشرف'), TextCellValue(homeController.currentUser!.userName)]);
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
    sheet.appendRow([TextCellValue('مندوب')]);
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

    for (int i = 0; i < reports.length; i++) {
      var report = reports[i];
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
    //var directory = await DownloadsPathProvider.downloadsDirectory; //todo: choose a suitable path

    File(join('/storage/emulated/0/Download/${homeController.currentUser!.userName}.xlsx'))
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes!);
    Get.showSnackbar(const GetSnackBar(
      message: "تم التخزين في مجلد التنزيلات",
      duration: Duration(milliseconds: 2500),
    ));
    //todo: instead of saving, share the file
    //todo: if the reports are empty -> return with a message
  }

  Future<void> uploadReport(ReportModel report) async {
    if (await RemoteServices.uploadReport(report)) {
      report.uploaded = true;
      LocalServices.storeReports(reports);
      update();
      Get.back();
      Get.showSnackbar(const GetSnackBar(
        message: "تم الارسال بنجاح",
        duration: Duration(milliseconds: 2500),
      ));
    } else {
      print("error when uploading");
    }
  }
}
