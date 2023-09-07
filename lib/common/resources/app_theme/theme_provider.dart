import 'package:ease_tour/common/resources/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;
  bool get isDark => themeMode == ThemeMode.dark;

  // Define a getter named 'provider' that returns a Provider
  static final provider = ChangeNotifierProvider<ThemeProvider>((ref) {
    return ThemeProvider();
  });

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

  _updateDarkColors() {
    // Implement your dark theme colors here
  }

  _updateLightColors() {
    // Implement your light theme colors here
  }

  _updateTextColors(Color color) {
    // Implement text color updates here
  }
}
