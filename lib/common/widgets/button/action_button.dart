import 'package:ease_tour/common/resources/app_theme/theme_provider.dart';
import 'package:ease_tour/common/resources/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ActionButton extends StatelessWidget {
  final Color? color;
  final Color? iconColor;
  final String icon;
  final VoidCallback? onTap;
  const ActionButton(
      {super.key, this.color, required this.icon, this.iconColor, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ThemeProvider value, child) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color ?? Styles.primaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: SvgPicture.asset(icon,
              color: iconColor ?? Styles.primaryIconColor,
              fit: BoxFit.scaleDown),
        ),
      ),
    );
  }
}
