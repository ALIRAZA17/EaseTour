import 'package:ease_tour/common/resources/constants/styles.dart';
import 'package:ease_tour/common/widgets/appBar/app_bar.dart';
import 'package:ease_tour/screens/transport/transport_selection/widgets/transport_options_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInOptionsScreen extends StatelessWidget {
  const SignInOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EtAppBar(
        height: 90,
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 26, right: 26),
        child: Column(
          children: [
            const SizedBox(
              height: 17,
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.only(left: 22, top: 27),
                decoration: BoxDecoration(
                  color: Styles.gradientColor,
                  borderRadius: BorderRadius.circular(11),
                ),
                width: 357,
                height: 162,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "HireCar",
                      style: Styles.displayXlBoldStyle.copyWith(
                        fontSize: 48,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      "Go anywhere, get anything",
                      style: Styles.displayMedNormalStyle,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 47,
            ),
            Center(
              child: Text(
                "Welcome",
                style: Styles.displayXlBoldStyle
                    .copyWith(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TransportOptionsContainer(
                  image: "signin.png",
                  title: "Sign In",
                  onTap: () {
                    Get.toNamed('/login');
                  },
                ),
                const SizedBox(
                  width: 20,
                ),
                TransportOptionsContainer(
                  image: "signup.png",
                  title: "Sign Up",
                  onTap: () {
                    Get.toNamed('/signup');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
