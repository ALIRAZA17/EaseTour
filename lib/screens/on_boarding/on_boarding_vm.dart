import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

import '../../../common/resources/app_theme/theme_provider.dart';

class OnBoardingViewModel extends BaseViewModel {
  bool isDark = false;
  void onSkipTap() {
    debugPrint('Skipped');
  }

  void onTapNext() async {
    debugPrint('Next is Tapped');
    if (await Permission.location.serviceStatus.isEnabled) {
      var status = await Permission.location.status;
      if (status.isGranted) {
        Get.offAllNamed('/main_screen');
      } else if (status.isDenied) {
        await [
          Permission.location,
        ].request();
      }
    }
  }

  void changeMode(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    isDark = !isDark;
    isDark
        ? themeProvider.changeAppTheme('dark')
        : themeProvider.changeAppTheme('light');
    notifyListeners();
  }
}
