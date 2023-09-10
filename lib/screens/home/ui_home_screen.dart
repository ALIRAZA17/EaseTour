import 'package:ease_tour/common/resources/constants/styles.dart';
import 'package:ease_tour/common/widgets/button/app_text_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final auth = FirebaseAuth.instance;

  void logout() async {
    await auth.signOut();
    Get.toNamed("/login");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(auth.currentUser!.uid),
            const SizedBox(
              height: 20,
            ),
            AppTextButton(
              text: "Log Out",
              onTap: logout,
              color: Styles.buttonColorPrimary,
            )
          ],
        ),
      ),
    );
  }
}
