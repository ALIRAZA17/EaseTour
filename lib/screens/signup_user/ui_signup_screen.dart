import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:ease_tour/common/resources/constants/styles.dart';
import 'package:ease_tour/common/widgets/appBar/app_bar.dart';
import 'package:ease_tour/common/widgets/button/app_text_button.dart';
import 'package:ease_tour/common/widgets/textFields/app_text_field.dart';
import 'package:ease_tour/screens/role/providers/role_provider.dart';
import 'package:ease_tour/screens/signup_user/providers/cnic_text_controller_provider.dart';
import 'package:ease_tour/screens/signup_user/providers/contact_text_controller_provider.dart';
import 'package:ease_tour/screens/signup_user/providers/email_text_controller_provider.dart';
import 'package:ease_tour/screens/signup_user/providers/gender_text_controller_provider.dart';
import 'package:ease_tour/screens/signup_user/providers/license_number_text_controller_provider.dart';
import 'package:ease_tour/screens/signup_user/providers/name_text_controller_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});
  static String verificationId = "";

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final formKey = GlobalKey<FormState>();

  bool isSignUpLoading = false;
  bool isGoogleSignInLoading = false;

  String? selectedValue;

  @override
  void initState() {
    super.initState();
    ref.read(emailTextControllerProvider).clear();
    ref.read(nameTextControllerProvider).clear();
    ref.read(contactTextControllerProvider).clear();
    ref.read(licenseNumberTextControllerProvider).clear();
    ref.read(cnicTextControllerProvider).clear();
  }

  Future<void> signUpWithGoogle() async {
    setState(() {
      isGoogleSignInLoading = true;
    });

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (authResult.user != null) {
        final user = authResult.user!;
        final uid = user.uid;

        final role = ref.watch(roleProvider.notifier).state;

        final userExists = await doesUserExistInFirebase(uid, role);

        if (userExists) {
          if (role == "users") {
            Get.toNamed("/onBoarding/primary");
          } else {
            Get.toNamed("/driver_welcome_screen");
          }
        } else {
          ref.read(emailTextControllerProvider).text = user.email ?? "";
          ref.read(nameTextControllerProvider).text = user.displayName ?? "";
          Get.toNamed("/app_user_info_screen");
        }
      }
    } catch (e) {
      Get.snackbar("Sign up with Google failed", "Please try again!");
    } finally {
      setState(() {
        isGoogleSignInLoading = false;
      });
    }
  }

  Future<bool> doesUserExistInFirebase(String uid, String role) async {
    try {
      final userDoc =
          await FirebaseFirestore.instance.collection(role).doc(uid).get();
      return userDoc.exists;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final emailController = ref.watch(emailTextControllerProvider);
    final nameController = ref.watch(nameTextControllerProvider);
    final contactController = ref.watch(contactTextControllerProvider);
    final cnicController = ref.watch(cnicTextControllerProvider);
    final licenseNoController = ref.watch(licenseNumberTextControllerProvider);
    final role = ref.read(roleProvider.notifier).state;

    final List<String> genderItems = [
      'Male',
      'Female',
    ];

    return Scaffold(
      appBar: const EtAppBar(
        height: 90,
      ),
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
                    DropdownButtonFormField2<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      hint: const Text(
                        'Select Your Gender',
                        style: TextStyle(fontSize: 14),
                      ),
                      items: genderItems
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ))
                          .toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'Please select gender.';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        selectedValue = value;
                        ref.read(genderProvider.notifier).state =
                            selectedValue ?? "Male";
                      },
                      onSaved: (value) {
                        selectedValue = value.toString();
                      },
                      buttonStyleData: const ButtonStyleData(
                        padding: EdgeInsets.only(right: 8),
                      ),
                      iconStyleData: const IconStyleData(
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black45,
                        ),
                        iconSize: 24,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (role == "drivers")
                      AppTextField(
                          label: "Cnic",
                          keyboardType: TextInputType.text,
                          controller: cnicController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Cnic';
                            }
                            return null;
                          }),
                    if (role == "drivers")
                      const SizedBox(
                        height: 20,
                      ),
                    if (role == "drivers")
                      AppTextField(
                        label: "License No.",
                        keyboardType: TextInputType.text,
                        controller: licenseNoController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter license no';
                          }
                          return null;
                        },
                      ),
                    if (role == "drivers")
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
                                        ..onTap = () {}),
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
                                          ..onTap = () {},
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
                    isSignUpLoading
                        ? const Center(child: CircularProgressIndicator())
                        : AppTextButton(
                            text: "Sign Up",
                            onTap: () async {
                              if (formKey.currentState!.validate()) {
                                setState(() {
                                  isSignUpLoading = true;
                                });

                                await FirebaseAuth.instance.verifyPhoneNumber(
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
                                    setState(() {
                                      isSignUpLoading = false;
                                    });
                                  },
                                  codeSent: (String verificationId,
                                      int? resendToken) {
                                    SignUpScreen.verificationId =
                                        verificationId;

                                    Get.toNamed('/signup/otp')
                                        ?.whenComplete(() {
                                      setState(() {
                                        isSignUpLoading = false;
                                      });
                                    });
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
                    isGoogleSignInLoading
                        ? const Center(child: CircularProgressIndicator())
                        : AppTextButton(
                            text: "Sign up with Gmail",
                            onTap: () {
                              if (!isGoogleSignInLoading) {
                                signUpWithGoogle();
                              }
                            },
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
                                  Get.toNamed('/login');
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
