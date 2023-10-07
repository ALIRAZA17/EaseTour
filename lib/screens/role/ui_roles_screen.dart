import 'package:ease_tour/common/resources/constants/styles.dart';
import 'package:ease_tour/common/widgets/appBar/app_bar.dart';
import 'package:ease_tour/common/widgets/button/app_text_button.dart';
import 'package:ease_tour/screens/role/providers/role_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class RolesScreen extends ConsumerWidget {
  const RolesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const EtAppBar(
        height: 90,
        addBackButton: false,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(
                height: 48,
              ),
              Center(
                child: Image.asset('assets/images/role_screen_main.jpg'),
              ),
              const SizedBox(
                height: 182,
              ),
            ],
          ),
          Positioned(
            bottom: 170,
            left: 0,
            right: 0,
            child: Center(
              child: AppTextButton(
                text: "Continue as a user",
                onTap: () {
                  ref.read(roleProvider.notifier).state = 'users';
                  Get.toNamed('/sign_in_options');
                },
                color: Styles.primaryColor,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Positioned(
            bottom: 105,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "OR",
                style: Styles.displayLargeNormalStyle.copyWith(
                  fontSize: 24,
                  color: Styles.lightGrayTextColor,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: AppTextButton(
                text: "Continue as a Driver",
                onTap: () {
                  ref.read(roleProvider.notifier).state = 'drivers';
                  Get.toNamed('/sign_in_options');
                },
                color: Styles.primaryColor,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
