import 'package:flutter/material.dart';

class AppSmallTextButton extends StatelessWidget {
  const AppSmallTextButton({
    Key? key,
    required this.text,
    required this.onTap,
    required this.color,
    this.textColor,
    this.addBorder = false,
    this.borderColor,
    this.fontSize = 16,
    this.width,
    this.height,
  }) : super(key: key);

  final String text;
  final VoidCallback onTap;
  final Color? color;
  final Color? textColor;
  final Color? borderColor;
  final bool addBorder;
  final double? fontSize;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
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
      child: SizedBox(
        width: width,
        height: height,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              color: textColor ?? Colors.white,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
