import 'package:flutter/material.dart';

class AppTextButton extends StatelessWidget {
  const AppTextButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.color,
    this.textColor,
    this.addBorder = false,
  });

  final String text;
  final VoidCallback onTap;
  final Color? color;
  final Color? textColor;
  final bool addBorder;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll<Color>(color ?? Colors.white),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Color.fromRGBO(184, 184, 184, 1)),
          ),
        ),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 20, vertical: 15.5),
        ),
      ),
      onPressed: onTap,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: textColor ?? Colors.white,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
