import 'package:ease_tour/common/resources/constants/styles.dart';
import 'package:ease_tour/common/widgets/appBar/app_bar.dart';
import 'package:ease_tour/common/widgets/button/app_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class DriverHomeView extends StatelessWidget {
  const DriverHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EtAppBar(height: 90),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: SvgPicture.asset('assets/images/background.svg'),
            ),
            Center(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 6,
                  ),
                  SvgPicture.asset('assets/images/home_img.svg'),
                  SizedBox(height: MediaQuery.of(context).size.height / 7),
                  AppTextButton(
                      text: 'Take a Ride',
                      onTap: () {
                        Get.toNamed('/driver_main_screen');
                      },
                      color: Styles.buttonColorPrimary)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
