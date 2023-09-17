import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';

class TertiaryViewModel extends BaseViewModel {
  void onSkipTap() {
    debugPrint('Skipped');
  }

  void onTapNext() async {
    debugPrint('Next is Tapped');
    if (await Permission.location.serviceStatus.isEnabled) {
      var status = await Permission.location.status;
      if (status.isGranted) {
        Get.offAllNamed('/home');
      } else if (status.isDenied) {
        await [
          Permission.location,
        ].request();
      }
    }
  }
}
