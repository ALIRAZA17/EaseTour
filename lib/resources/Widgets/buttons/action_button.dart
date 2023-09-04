import 'package:ease_tour/resources/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:provider/provider.dart';

import '../../app_theme/theme_provider.dart';

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
            color: color ?? Styles.actionButtonColorPrimary,
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
