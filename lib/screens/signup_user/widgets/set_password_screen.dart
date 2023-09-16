import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_tour/common/resources/constants/styles.dart';
import 'package:ease_tour/common/widgets/appBar/app_bar.dart';
import 'package:ease_tour/common/widgets/button/app_text_button.dart';
import 'package:ease_tour/common/widgets/textFields/app_text_field.dart';
import 'package:ease_tour/models/appUser.dart';
import 'package:ease_tour/screens/role/providers/role_provider.dart';
import 'package:ease_tour/screens/signup_user/providers/confirm_password_text_controller_provider.dart';
import 'package:ease_tour/screens/signup_user/providers/contact_text_controller_provider.dart';
import 'package:ease_tour/screens/signup_user/providers/email_text_controller_provider.dart';
import 'package:ease_tour/screens/signup_user/providers/gender_text_controller_provider.dart';
import 'package:ease_tour/screens/signup_user/providers/name_text_controller_provider.dart';
import 'package:ease_tour/screens/signup_user/providers/password_text_controller_provider.dart';
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
  bool isRegisterLoading = false; // Add this flag

  @override
  void initState() {
    super.initState();
    ref.read(passswordTextControllerProvider).clear();
  }

  Future<User?> saveUser(AppUser user, String role) async {
    try {
      setState(() {
        isRegisterLoading = true;
      });

      UserCredential credential = await auth.createUserWithEmailAndPassword(
          email: user.email, password: user.password);

      CollectionReference users = FirebaseFirestore.instance.collection(role);

      String uid = FirebaseAuth.instance.currentUser!.uid;

      DocumentReference userRef = users.doc(uid);

      userRef
          .set({
            'full_name': user.name,
            'email': user.email,
            'password': user.password,
            'contact': user.contactNumber,
            'gender': user.gender,
          })
          .then((value) =>
              Get.snackbar("User Added", "User has been added successfully!"))
          .catchError(
            (error) => Get.snackbar("Process Failed", "Error: $error"),
          );

      Get.toNamed('/login');
      return credential.user;
    } catch (e) {
      Get.snackbar("Process Failed", "Error: $e");
    } finally {
      setState(() {
        isRegisterLoading = false;
      });
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
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AppTextField(
                            label: "Enter Your Password",
                            keyboardType: TextInputType.text,
                            controller: passwordController,
                            validator: (value) {
                              return null;
                            },
                            obscureText: true,
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
                            "At least 1 number or a special character",
                            style: Styles.displaySmNormalStyle.copyWith(
                              color: Styles.secondryTextColor,
                              fontSize: 14,
                            ),
                          ),
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
              child: isRegisterLoading
                  ? const Center(child: CircularProgressIndicator())
                  : AppTextButton(
                      color: Styles.buttonColorPrimary,
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          final contactNumber =
                              ref.read(contactTextControllerProvider).text;
                          final gender =
                              ref.read(genderProvider.notifier).state;
                          final email =
                              ref.read(emailTextControllerProvider).text;
                          final password =
                              ref.read(passswordTextControllerProvider).text;
                          final name =
                              ref.read(nameTextControllerProvider).text;

                          String role = ref.read(roleProvider.notifier).state;

                          if (role == "users") {
                            final user = AppUser(
                                contactNumber: contactNumber,
                                gender: gender,
                                email: email,
                                password: password,
                                name: name);
                            saveUser(user, role);
                          } else {
                            Get.toNamed('/transport_details');
                          }
                        }
                      },
                      text: "Register",
                      textColor: Colors.white,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
