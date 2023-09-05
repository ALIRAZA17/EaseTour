import 'package:ease_tour/common/resources/constants/styles.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;
  bool get isDark => themeMode == ThemeMode.dark;
  changeAppTheme(String theme) {
    if (theme == 'dark') {
      themeMode = ThemeMode.dark;
    } else {
      themeMode = ThemeMode.light;
    }
    _updateColorScheme();
    notifyListeners();
  }

  _updateColorScheme() {
    if (themeMode == ThemeMode.dark) {
      _updateDarkColors();
      _updateTextColors(Colors.white);
    } else {
      _updateLightColors();
      _updateTextColors(Styles.primaryTextColor);
    }
  }

  _updateDarkColors() {}
  _updateLightColors() {}
  _updateTextColors(Color color) {}
}
