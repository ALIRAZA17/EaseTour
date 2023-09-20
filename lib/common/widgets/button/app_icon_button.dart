import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    Key? key,
    required this.onTap,
    required this.color,
    this.textColor,
    this.addBorder = false,
    this.borderColor,
    this.fontSize = 16,
    required this.icon,
  }) : super(key: key);

  final VoidCallback onTap;
  final Color? color;
  final Color? textColor;
  final Color? borderColor;
  final bool addBorder;
  final double? fontSize;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll<Color>(color ?? Colors.white),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
                color: borderColor ?? const Color.fromRGBO(184, 184, 184, 1)),
          ),
        ),
      ),
      onPressed: onTap,
      icon: icon,
      color: Colors.white,
    );
  }
}
