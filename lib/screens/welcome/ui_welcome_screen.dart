import 'package:ease_tour/common/widgets/button/app_text_button.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 18, right: 18),
                          child:
                              Image.asset('assets/images/welcome_screen.jpg')),
                      const SizedBox(
                        height: 29,
                      ),
                      const Text(
                        "Welcome",
                        style: TextStyle(fontSize: 24),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Have a better sharing experience",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromRGBO(160, 160, 160, 1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 80,
              child: AppTextButton(
                text: "Create an Account",
                onTap: () {},
                color: const Color.fromRGBO(0, 137, 85, 1),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 10,
              child: AppTextButton(
                color: null,
                onTap: () {},
                text: "Login",
                textColor: const Color.fromRGBO(0, 137, 85, 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
