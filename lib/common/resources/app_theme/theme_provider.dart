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
      _updateTextColors(Colors.white, const Color.fromARGB(255, 224, 216, 216));
    } else {
      _updateLightColors();
      _updateTextColors(const Color(0xff414141), const Color(0xffA0A0A0));
    }
  }

  _updateDarkColors() {
    Styles.backgroundColor = Colors.black;
    notifyListeners();
  }

  _updateLightColors() {
    Styles.backgroundColor = Colors.white;
    notifyListeners();
  }

  _updateTextColors(Color primaryColor, Color secondryColor) {
    Styles.primaryTextColor = primaryColor;
    Styles.secondryTextColor = secondryColor;
    notifyListeners();
  }
}
