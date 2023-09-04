import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

class SecondryViewModel extends BaseViewModel {
  void onSkipTap() {
    debugPrint('Skipped');
  }

  void onTapNext() {
    Get.toNamed('/onBoarding/tertiary');
    debugPrint('Next is Tapped');
  }
}
