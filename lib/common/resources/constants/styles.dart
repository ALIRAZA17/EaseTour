import 'package:flutter/material.dart';

class Styles {
  //Light Mode Colors

  static Color backgroundColor = Colors.white;

  static Color primaryColor = const Color.fromRGBO(0, 175, 245, 100);

  static Color primaryColorLight = const Color(0xffE2F5ED);
  static Color primaryColorMed = const Color(0xffB9E5D1);

  static Color buttonColorPrimary = const Color.fromRGBO(0, 175, 245, 100);
  static Color actionButtonColorPrimary = const Color(0xff8AD4B5);

  static Color primaryTextColor = const Color(0xff414141);
  static Color secondryTextColor = const Color(0xffA0A0A0);
  static Color tertiaryTextColor = const Color.fromRGBO(208, 208, 208, 1);
  static Color lightGrayTextColor = const Color.fromRGBO(184, 184, 184, 1);

  static Color primaryIconColor = const Color(0xff414141);

  static Color primaryButtonTextColor = Colors.white;
  static Color secondryButtonTextColor = primaryColorMed;

  static Color blackTextColor = const Color.fromRGBO(208, 208, 208, 1);

  static Color transportSelectContainerColor =
      const Color.fromRGBO(226, 245, 237, 1);

  //Light Mode TextStyles

  static TextStyle displayXlNormalStyle = const TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w500,
  );
  static TextStyle displayXlBoldStyle = const TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w600,
  );

  static TextStyle displayLargeNormalStyle = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );

  static TextStyle displaySmNormalStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static TextStyle displayMedNormalStyle = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );
  static TextStyle displayMedLightStyle = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
  );
}
