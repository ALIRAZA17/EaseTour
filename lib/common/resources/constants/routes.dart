import 'package:ease_tour/screens/driver_home/ui_driver_home_screen.dart';
import 'package:ease_tour/screens/driver_main/ui_driver_main_screen.dart';
import 'package:ease_tour/screens/driver_main/widgets/incoming_rides/incoming_rides_screen.dart';
import 'package:ease_tour/screens/history/history_vu.dart';
import 'package:ease_tour/screens/login/ui_login_screen.dart';
import 'package:ease_tour/screens/on_boarding/primary/primary_vu.dart';
import 'package:ease_tour/screens/on_boarding/secondry/secondry_vu.dart';
import 'package:ease_tour/screens/on_boarding/tertiary/tertiary_vu.dart';
import 'package:ease_tour/screens/role/ui_roles_screen.dart';
import 'package:ease_tour/screens/settings/settings_vu.dart';
import 'package:ease_tour/screens/signup_user/ui_signup_screen.dart';
import 'package:ease_tour/screens/signup_user/widgets/app_user_info_screen.dart';
import 'package:ease_tour/screens/signup_user/widgets/otp_verification_screen.dart';
import 'package:ease_tour/screens/signup_user/widgets/set_password_screen.dart';
import 'package:ease_tour/screens/signup_user/widgets/transport_details.dart';
import 'package:ease_tour/screens/transport/transport_selection/ui_select_transport_screen.dart';
import 'package:ease_tour/screens/user_home/home_vu.dart';
import 'package:ease_tour/screens/welcome/ui_welcome_screen.dart';
import 'package:ease_tour/screens/pickup/pickup_vu.dart';
import 'package:ease_tour/screens/user_main/user_main_vu.dart';
import 'package:ease_tour/screens/on_boarding/on_boarding_vu.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

appRoutes() => [
      GetPage(
        name: '/onBoarding',
        page: () => const OnBoardingView(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 200),
      ),
      GetPage(
        name: '/main_screen',
        page: () => const UserMainView(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 200),
      ),
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
      GetPage(
        name: '/home',
        page: () => const HomeView(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 200),
      ),
      GetPage(
        name: '/pickup',
        page: () => const PickupView(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 200),
      ),
      GetPage(
        name: '/driver_welcome_screen',
        page: () => const DriverHomeView(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 200),
      ),
      GetPage(
        name: '/driver_main_screen',
        page: () => const DriverMainScreen(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 200),
      ),
      GetPage(
        name: '/driver_incoming_rides',
        page: () => const IncomingRides(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 200),
      ),
      GetPage(
        name: '/app_user_info_screen',
        page: () => const AppUserInfoScreen(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 200),
      ),
      GetPage(
        name: '/history',
        page: () => const HistroyView(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 200),
      ),
      GetPage(
        name: '/settings',
        page: () => const SettingsView(),
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
