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
    ];

class MyMiddelware extends GetMiddleware {
  @override
  GetPage? onPageCalled(GetPage? page) {
    debugPrint(page?.name);
    return super.onPageCalled(page);
  }
}
