import 'package:ease_tour/common/resources/constants/styles.dart';
import 'package:ease_tour/common/widgets/appBar/app_bar.dart';
import 'package:ease_tour/common/widgets/button/app_text_button.dart';
import 'package:ease_tour/common/widgets/textFields/app_text_field.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EtAppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Text(
                "Sign up with your email or phone number",
                style: Styles.displayLargeNormalStyle.copyWith(
                  fontSize: 24,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AppTextField(
                      label: "Name",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const AppTextField(
                      label: "Email",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const AppTextField(
                      label: "Mobile Number",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const AppTextField(
                      label: "Gender",
                    ),
                    const SizedBox(
                      height: 96,
                    ),
                    AppTextButton(
                      text: "Sign Up",
                      onTap: () {},
                      color: Styles.buttonColorPrimary,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
