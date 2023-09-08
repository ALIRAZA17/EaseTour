import 'package:ease_tour/common/resources/constants/styles.dart';
import 'package:ease_tour/common/widgets/appBar/app_bar.dart';
import 'package:ease_tour/common/widgets/button/app_text_button.dart';
import 'package:ease_tour/common/widgets/textFields/app_text_field.dart';
import 'package:ease_tour/screens/signup/providers/otp_text_controller_provider.dart';
import 'package:ease_tour/screens/signup/ui_signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OtpVerificationScreen extends ConsumerWidget {
  OtpVerificationScreen({super.key});

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otpController = ref.watch(otpTextControllerProvider);
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
                            text: 'Didnt recieve code? ',
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
                                  ..onTap = () {
                                    // code to handle the sign-in action
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
                child: AppTextButton(
                  color: Styles.buttonColorPrimary,
                  onTap: () async {
                    PhoneAuthCredential credential =
                        PhoneAuthProvider.credential(
                      verificationId: SignUpScreen.verificationId,
                      smsCode: otpController.text,
                    );

                    await auth.signInWithCredential(credential);
                  },
                  text: "Verify",
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
        ));
  }
}
