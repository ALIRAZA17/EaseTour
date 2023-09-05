import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

import '../../../common/resources/app_theme/theme_provider.dart';

class TertiaryViewModel extends BaseViewModel {
  bool isDark = false;
  void onSkipTap() {
    debugPrint('Skipped');
  }

  void onTapNext() {
    debugPrint('Next is Tapped');
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
