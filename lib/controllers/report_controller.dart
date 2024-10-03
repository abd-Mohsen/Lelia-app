import 'package:get/get.dart';

class ReportController extends GetxController {
  int _picIndex = 0;
  int get picIndex => _picIndex;
  void setPicIndex(int i) {
    _picIndex = i;
    update();
  }
}
