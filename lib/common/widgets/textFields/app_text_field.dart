import 'package:ease_tour/common/resources/constants/styles.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField(
      {super.key,
      required this.label,
      required this.keyboardType,
      required this.controller,
      required this.validator});

  final String label;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        label: Text(
          label,
          style: Styles.displaySmNormalStyle.copyWith(
            color: Styles.tertiaryTextColor,
          ),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
          borderSide: BorderSide(
            color: Color.fromRGBO(184, 184, 184, 1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Styles.primaryColor),
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        contentPadding: const EdgeInsets.only(
          left: 20,
          top: 19,
          bottom: 18,
        ),
      ),
      keyboardType: keyboardType,
      controller: controller,
      validator: validator,
    );
  }
}
