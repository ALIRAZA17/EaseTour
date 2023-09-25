import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

class HistoryViewModel extends BaseViewModel {
  void onBackPressed() {
    debugPrint('Back Pressed');
    Get.back();
  }
}
