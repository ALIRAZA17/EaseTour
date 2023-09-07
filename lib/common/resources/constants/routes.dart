import 'package:ease_tour/screens/on_boarding/primary/primary_vu.dart';
import 'package:ease_tour/screens/on_boarding/secondry/secondry_vu.dart';
import 'package:ease_tour/screens/on_boarding/tertiary/tertiary_vu.dart';
import 'package:ease_tour/screens/signup/ui_signup_screen.dart';
import 'package:ease_tour/screens/signup/widgets/otp_verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

appRoutes() => [
      GetPage(
        name: '/onBoarding/primary',
        page: () => const PrimaryView(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 200),
      ),
      GetPage(
        name: '/onBoarding/secondry',
        page: () => const SecondryView(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 200),
      ),
      GetPage(
        name: '/onBoarding/tertiary',
        page: () => const TertiaryView(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 200),
      ),
      GetPage(
        name: '/signup',
        page: () => const SignUpScreen(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 200),
      ),
      GetPage(
        name: '/signup/otp',
        page: () => const OtpVerificationScreen(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 200),
      )
    ];

class MyMiddelware extends GetMiddleware {
  @override
  GetPage? onPageCalled(GetPage? page) {
    debugPrint(page?.name);
    return super.onPageCalled(page);
  }
}
