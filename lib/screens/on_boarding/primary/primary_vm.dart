import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

class PrimaryViewModel extends BaseViewModel {
  void onSkipTap() {
    debugPrint('Skipped');
  }

  void onTapNext() {
    Get.toNamed('/onBoarding/secondry');
    debugPrint('Next Page Incoming');
  }
}
