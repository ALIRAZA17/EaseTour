import 'dart:async';

import 'package:ease_tour/common/resources/constants/styles.dart';
import 'package:ease_tour/common/widgets/appBar/app_bar.dart';
import 'package:ease_tour/common/widgets/button/app_text_button.dart';
import 'package:ease_tour/common/widgets/textFields/app_text_field.dart';
import 'package:ease_tour/screens/signup_user/providers/contact_text_controller_provider.dart';
import 'package:ease_tour/screens/signup_user/providers/otp_text_controller_provider.dart';
import 'package:ease_tour/screens/signup_user/ui_signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final auth = FirebaseAuth.instance;

  bool isVerifyLoading = false;
  bool isResendLoading = false; // Add this flag

  @override
  Widget build(BuildContext context) {
    final otpController = ref.watch(otpTextControllerProvider);
    final contactController = ref.read(contactTextControllerProvider);

    return Scaffold(
      appBar: const EtAppBar(),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Text(
                        "Phone Verification",
                        style: Styles.displayLargeNormalStyle.copyWith(
                          fontSize: 24,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      "Enter your OTP code",
                      style: Styles.displaySmNormalStyle.copyWith(
                        color: Styles.secondryTextColor,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    AppTextField(
                      label: "OTP code",
                      keyboardType: TextInputType.number,
                      controller: otpController,
                      validator: (value) {
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: 'Didn\'t receive code? ',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Resend again',
                              style: TextStyle(
                                fontSize: 16,
                                color: Styles.buttonColorPrimary,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  setState(() {
                                    isResendLoading = true;
                                  });

                                  try {
                                    await FirebaseAuth.instance
                                        .verifyPhoneNumber(
                                      phoneNumber: contactController.text,
                                      verificationCompleted:
                                          (PhoneAuthCredential credential) {
                                        Get.snackbar(
                                          "Verification Completed",
                                          "Verification Completed Successfully!!",
                                        );
                                      },
                                      verificationFailed:
                                          (FirebaseAuthException e) {
                                        Get.snackbar(
                                          "Verification Failed",
                                          "An error occurred while sending OTP. Please try again later.",
                                        );
                                      },
                                      codeSent: (String verificationId,
                                          int? resendToken) {
                                        SignUpScreen.verificationId =
                                            verificationId;
                                        Get.toNamed('/signup/otp')
                                            ?.whenComplete(() {
                                          setState(() {
                                            isResendLoading = false;
                                          });
                                        });
                                      },
                                      codeAutoRetrievalTimeout:
                                          (String verificationId) {},
                                    );
                                  } finally {
                                    setState(() {
                                      isResendLoading = false;
                                    });
                                  }
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 5,
              child: isVerifyLoading
                  ? const Center(child: CircularProgressIndicator())
                  : AppTextButton(
                      color: Styles.buttonColorPrimary,
                      onTap: () async {
                        setState(() {
                          isVerifyLoading = true;
                        });

                        try {
                          PhoneAuthCredential credential =
                              PhoneAuthProvider.credential(
                            verificationId: SignUpScreen.verificationId,
                            smsCode: otpController.text,
                          );

                          UserCredential authResult = await FirebaseAuth
                              .instance
                              .signInWithCredential(credential);

                          if (authResult.user != null) {
                            await authResult.user?.delete();
                            Get.toNamed('/signup/setPasswordScreen');
                          } else {
                            Get.snackbar(
                                "Signup failed", "Unable to create a user");
                          }
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'invalid-verification-code') {
                            Get.snackbar(
                                "Invalid verification code", "Code is wrong");
                          } else {
                            Get.snackbar("Signup failed",
                                "An error occurred during verification");
                          }
                        } on TimeoutException {
                          Get.snackbar("Timeout",
                              "The OTP verification process has timed out. Please try again.");
                        } finally {
                          setState(() {
                            isVerifyLoading = false;
                          });
                        }
                      },
                      text: "Verify",
                      textColor: Colors.white,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
