import 'package:ease_tour/screens/bottom_nav/bottom_nav_vu.dart';
import 'package:ease_tour/screens/on_boarding/primary/primary_vu.dart';
import 'package:ease_tour/screens/on_boarding/secondry/secondry_vu.dart';
import 'package:ease_tour/screens/on_boarding/tertiary/tertiary_vu.dart';
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
        name: '/main_screen',
        page: () => const BottomNavView(),
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
