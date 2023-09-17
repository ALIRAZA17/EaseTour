import 'package:ease_tour/common/resources/constants/styles.dart';
import 'package:flutter/material.dart';

class Themes {
  static ThemeData lightThemeData() {
    return ThemeData(
      fontFamily: 'Poppins',
      brightness: Brightness.light,
      primaryColor: Styles.primaryColor,
      scaffoldBackgroundColor: Styles.backgroundColor,
      bottomSheetTheme:
          BottomSheetThemeData(backgroundColor: Styles.primaryColor),
    );
  }

// dark Theme
  static ThemeData darkThemeData() {
    return ThemeData(
      fontFamily: 'Poppins',
      brightness: Brightness.dark,
      primaryColor: Styles.primaryColor,
      scaffoldBackgroundColor: Styles.backgroundColor,
      bottomSheetTheme:
          BottomSheetThemeData(backgroundColor: Styles.backgroundColor),
    );
  }
}
