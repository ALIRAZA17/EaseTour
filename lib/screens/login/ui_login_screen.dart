import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_tour/common/resources/constants/styles.dart';
import 'package:ease_tour/common/widgets/button/app_text_button.dart';
import 'package:ease_tour/common/widgets/textFields/app_text_field.dart';
import 'package:ease_tour/screens/role/providers/role_provider.dart';
import 'package:ease_tour/screens/signup_user/providers/email_text_controller_provider.dart';
import 'package:ease_tour/screens/signup_user/providers/password_text_controller_provider.dart';
import 'package:ease_tour/screens/user_main/providers/user_uid_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  static String verificationId = "";

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  bool isGoogleSignInLoading = false;

  @override
  void initState() {
    super.initState();
    ref.read(passswordTextControllerProvider).clear();
    ref.read(emailTextControllerProvider).clear();
  }

  Future<void> signInWithGoogle() async {
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

      await FirebaseAuth.instance.signInWithCredential(credential);

      if (FirebaseAuth.instance.currentUser != null) {
        Get.toNamed('/myScreen');
      }
    } catch (e) {
      Get.snackbar("Sign in with Google failed", "Please try again!");
    } finally {
      setState(() {
        isGoogleSignInLoading = false;
      });
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      setState(() {
        isLoading = true;
      });

      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // Get.toNamed('/home');
    } catch (e) {
      Get.snackbar("Sign in failed",
          "Your password or email is wrong. Please try again!");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final emailController = ref.watch(emailTextControllerProvider);
    final passwordController = ref.watch(passswordTextControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Text(
                  "Sign in with your email and password",
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
                        label: "Password",
                        keyboardType: TextInputType.text,
                        controller: passwordController,
                        validator: (value) {
                          return null;
                        },
                        obscureText: true,
                      ),
                      const SizedBox(
                        height: 69,
                      ),
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : AppTextButton(
                              text: "Sign In",
                              onTap: () async {
                                if (formKey.currentState!.validate()) {
                                  final email = ref
                                      .read(emailTextControllerProvider)
                                      .text;

                                  final password = ref
                                      .read(passswordTextControllerProvider)
                                      .text;
                                  await signIn(email, password);

                                  ref.read(userIdProvider.notifier).state =
                                      FirebaseAuth.instance.currentUser!.uid;

                                  final doc = await FirebaseFirestore.instance
                                      .collection('drivers')
                                      .doc(ref.read(userIdProvider))
                                      .get();
                                  Map<String, dynamic>? docData = doc.data();
                                  debugPrint('======================>$docData');

                                  // Get.offAllNamed('onBoarding/primary');

                                  Get.offAllNamed('driver_welcome_screen');
                                  // Get.offAllNamed('onBoarding/primary');
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 7.0),
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
                              text: "Sign in with Gmail",
                              onTap: () async {
                                if (isGoogleSignInLoading) {
                                  return;
                                }
                                setState(() {
                                  isGoogleSignInLoading = true;
                                });

                                try {
                                  await signInWithGoogle();
                                } catch (e) {
                                  Get.snackbar("Sign in with Google failed",
                                      "Please try again!");
                                } finally {
                                  setState(() {
                                    isGoogleSignInLoading = false;
                                  });
                                }
                              },
                              color: Styles.primaryButtonTextColor,
                              textColor: Colors.black,
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      AppTextButton(
                        text: "Sign in with Apple",
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
                            text: "Don't have an Account? ",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Sign Up',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Styles.buttonColorPrimary,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.toNamed('/role_screen');
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
      ),
    );
  }
}
