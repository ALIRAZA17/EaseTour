import 'package:ease_tour/common/resources/constants/styles.dart';
import 'package:ease_tour/common/widgets/appBar/app_bar.dart';
import 'package:ease_tour/common/widgets/button/app_text_button.dart';
import 'package:ease_tour/common/widgets/textFields/app_text_field.dart';
import 'package:ease_tour/screens/signup/providers/otp_text_controller_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SetPasswordScreen extends ConsumerWidget {
  SetPasswordScreen({super.key});

  final auth = FirebaseAuth.instance;

  void saveUser() {}

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
                          "Set Password",
                          style: Styles.displayLargeNormalStyle.copyWith(
                            fontSize: 24,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Set your password",
                        style: Styles.displaySmNormalStyle.copyWith(
                          color: Styles.secondryTextColor,
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      AppTextField(
                        label: "Enter Your Password",
                        keyboardType: TextInputType.number,
                        controller: otpController,
                        validator: (value) {
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AppTextField(
                        label: "Confirm Password",
                        keyboardType: TextInputType.number,
                        controller: otpController,
                        validator: (value) {
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Atleast 1 number or a special character",
                        style: Styles.displaySmNormalStyle.copyWith(
                          color: Styles.secondryTextColor,
                          fontSize: 14,
                        ),
                      )
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
                  onTap: saveUser,
                  text: "Register",
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
        ));
  }
}
