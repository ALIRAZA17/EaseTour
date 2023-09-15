import 'package:ease_tour/screens/home/ui_home_screen.dart';
import 'package:ease_tour/screens/login/ui_login_screen.dart';
import 'package:ease_tour/screens/on_boarding/primary/primary_vu.dart';
import 'package:ease_tour/screens/on_boarding/secondry/secondry_vu.dart';
import 'package:ease_tour/screens/on_boarding/tertiary/tertiary_vu.dart';
import 'package:ease_tour/screens/role/ui_roles_screen.dart';
import 'package:ease_tour/screens/signup_user/ui_signup_screen.dart';
import 'package:ease_tour/screens/signup_user/widgets/otp_verification_screen.dart';
import 'package:ease_tour/screens/signup_user/widgets/set_password_screen.dart';
import 'package:ease_tour/screens/signup_user/widgets/transport_details.dart';
import 'package:ease_tour/screens/transport/transport_selection/ui_select_transport_screen.dart';
import 'package:ease_tour/screens/welcome/ui_welcome_screen.dart';
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
        page: () => OtpVerificationScreen(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 200),
      ),
      GetPage(
        name: '/signup/setPasswordScreen',
        page: () => const SetPasswordScreen(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 200),
      ),
      GetPage(
        name: '/login',
        page: () => const LoginScreen(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 200),
      ),
      GetPage(
        name: '/home',
        page: () => const HomeScreen(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 200),
      ),
      GetPage(
        name: '/home/transport_selection',
        page: () => const SelectTransportScreen(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 200),
      ),
      GetPage(
        name: '/welcome_screen',
        page: () => const WelcomeScreen(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 200),
      ),
      GetPage(
        name: '/role_screen',
        page: () => const RolesScreen(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 200),
      ),
      GetPage(
        name: '/transport_details',
        page: () => const TransportDetails(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 200),
      ),
    ];

class MyMiddelware extends GetMiddleware {
  @override
  GetPage? onPageCalled(GetPage? page) {
    debugPrint(page?.name);
    return super.onPageCalled(page);
  }
}
