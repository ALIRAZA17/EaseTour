import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

class SettingsViewModel extends BaseViewModel {
  void onBackPressed() {
    debugPrint('Back Pressed');
    Get.back();
  }

  void onChnagePassword() {
    debugPrint('onChnagePassword');
  }

  void onChnageLanguge() {
    debugPrint('onChnageLanguge');
  }

  void onPrivacyPolicy() {
    debugPrint('onPrivacyPolicy');
  }

  void onContactUs() {
    debugPrint('onContactUs');
  }

  void onDeleteAcc() {
    debugPrint('onDeleteAcc');
  }
}
