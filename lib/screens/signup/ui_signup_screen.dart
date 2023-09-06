import 'package:ease_tour/common/resources/constants/styles.dart';
import 'package:ease_tour/common/widgets/appBar/app_bar.dart';
import 'package:ease_tour/common/widgets/button/app_text_button.dart';
import 'package:ease_tour/common/widgets/textFields/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

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
                      height: 20,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color:
                                Styles.primaryColor, // Color for the check icon
                            size: 24, // Adjust the size as needed
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text.rich(
                              TextSpan(
                                text: 'By signing up, you agree to the ',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Styles.lightGrayTextColor,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Terms of Service',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Styles.primaryColor,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          // code to open / launch terms of service link here
                                        }),
                                  TextSpan(
                                    text: ' and ',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Styles.lightGrayTextColor,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Privacy Policy',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Styles.primaryColor,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            // code to open / launch privacy policy link here
                                          },
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    AppTextButton(
                      text: "Sign Up",
                      onTap: () {},
                      color: Styles.buttonColorPrimary,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Divider(
                            color: Styles.lightGrayTextColor,
                            height: 1.5,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 7.0),
                          child: Text(
                            "or",
                            style: Styles.displaySmNormalStyle.copyWith(
                              color: Styles.lightGrayTextColor,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Styles.lightGrayTextColor,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AppTextButton(
                      text: "Sign up with Gmail",
                      onTap: () {},
                      color: Styles.primaryButtonTextColor,
                      textColor: Colors.black,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AppTextButton(
                      text: "Sign up with Facebook",
                      onTap: () {},
                      color: Styles.primaryButtonTextColor,
                      textColor: Colors.black,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AppTextButton(
                      text: "Sign up with Apple",
                      onTap: () {},
                      color: Styles.primaryButtonTextColor,
                      textColor: Colors.black,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: 'Already have an Account? ',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Sign in',
                              style: TextStyle(
                                fontSize: 16,
                                color: Styles.buttonColorPrimary,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // code to handle the sign-in action
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
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
