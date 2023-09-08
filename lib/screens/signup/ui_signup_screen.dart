import 'package:ease_tour/common/resources/constants/styles.dart';
import 'package:ease_tour/common/widgets/appBar/app_bar.dart';
import 'package:ease_tour/common/widgets/button/app_text_button.dart';
import 'package:ease_tour/common/widgets/textFields/app_text_field.dart';
import 'package:ease_tour/screens/signup/providers/contact_text_controller_provider.dart';
import 'package:ease_tour/screens/signup/providers/email_text_controller_provider.dart';
import 'package:ease_tour/screens/signup/providers/gender_text_controller_provider.dart';
import 'package:ease_tour/screens/signup/providers/name_text_controller_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});
  static String verificationId = "";

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final emailController = ref.watch(emailTextControllerProvider);
    final nameController = ref.watch(nameTextControllerProvider);
    final contactController = ref.watch(contactTextControllerProvider);
    final genderController = ref.watch(genderTextControllerProvider);

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
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppTextField(
                      label: "Name",
                      keyboardType: TextInputType.name,
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Name is required';
                        } else if (!RegExp(r'^[a-z A-Z]').hasMatch(
                          value,
                        )) {
                          return "Enter Correct Name";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AppTextField(
                      label: "Email",
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        } else if (!RegExp(
                                r'^([a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})')
                            .hasMatch(
                          value,
                        )) {
                          return "Enter a valid email address";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AppTextField(
                      label: "Mobile Number",
                      keyboardType: TextInputType.text,
                      controller: contactController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Mobile Number is required';
                        } else if (!RegExp(
                                r'^((\+92)|(0092))-{0,1}\d{3}-{0,1}\d{7}$|^\d{11}$|^\d{4}-\d{7}')
                            .hasMatch(
                          value,
                        )) {
                          return "Enter valid mobile number";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AppTextField(
                      label: "Gender",
                      keyboardType: TextInputType.text,
                      controller: genderController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Gender is required';
                        }
                        return null;
                      },
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
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          await FirebaseAuth.instance.verifyPhoneNumber(
                            phoneNumber: contactController.text,
                            verificationCompleted:
                                (PhoneAuthCredential credential) {},
                            verificationFailed: (FirebaseAuthException e) {},
                            codeSent:
                                (String verificationId, int? resendToken) {
                              SignUpScreen.verificationId = verificationId;
                              Get.toNamed('/signup/otp');
                            },
                            codeAutoRetrievalTimeout:
                                (String verificationId) {},
                          );
                        }
                      },
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
