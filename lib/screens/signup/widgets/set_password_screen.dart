import 'package:ease_tour/common/resources/constants/styles.dart';
import 'package:ease_tour/common/widgets/appBar/app_bar.dart';
import 'package:ease_tour/common/widgets/button/app_text_button.dart';
import 'package:ease_tour/common/widgets/textFields/app_text_field.dart';
import 'package:ease_tour/models/appUser.dart';
import 'package:ease_tour/screens/signup/providers/confirm_password_text_controller_provider.dart';
import 'package:ease_tour/screens/signup/providers/contact_text_controller_provider.dart';
import 'package:ease_tour/screens/signup/providers/email_text_controller_provider.dart';
import 'package:ease_tour/screens/signup/providers/gender_text_controller_provider.dart';
import 'package:ease_tour/screens/signup/providers/name_text_controller_provider.dart';
import 'package:ease_tour/screens/signup/providers/otp_text_controller_provider.dart';
import 'package:ease_tour/screens/signup/providers/password_text_controller_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class SetPasswordScreen extends ConsumerStatefulWidget {
  const SetPasswordScreen({super.key});

  @override
  ConsumerState<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends ConsumerState<SetPasswordScreen> {
  final auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();

  Future<User?> saveUser(AppUser user) async {
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(
          email: user.email, password: user.password);
      Get.toNamed('/home');
      return credential.user;
    } catch (e) {
      print(e);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final passwordController = ref.watch(passswordTextControllerProvider);
    final confirmPasswordController =
        ref.watch(confirmPasswordTextControllerProvider);
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
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            AppTextField(
                              label: "Enter Your Password",
                              keyboardType: TextInputType.text,
                              controller: passwordController,
                              validator: (value) {
                                return null;
                              },
                              obscureText: false,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            AppTextField(
                              label: "Confirm Password",
                              keyboardType: TextInputType.text,
                              controller: confirmPasswordController,
                              validator: (value) {
                                if (passwordController.text !=
                                    confirmPasswordController.text) {
                                  return "Both Passwords should match";
                                }
                                return null;
                              },
                              obscureText: true,
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
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      final contactNumber =
                          ref.read(contactTextControllerProvider).text;
                      final gender =
                          ref.read(genderTextControllerProvider).text;
                      final email = ref.read(emailTextControllerProvider).text;
                      final password =
                          ref.read(passswordTextControllerProvider).text;
                      final name = ref.read(nameTextControllerProvider).text;

                      print("I am $email");
                      print("I am $password");
                      final user = AppUser(
                          contactNumber: contactNumber,
                          gender: gender,
                          email: email,
                          password: password,
                          name: name);
                      saveUser(user);
                    }
                  },
                  text: "Register",
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
        ));
  }
}
