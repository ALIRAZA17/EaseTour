import 'package:ease_tour/common/resources/constants/styles.dart';
import 'package:flutter/material.dart';

class RideProcessingScreen extends StatelessWidget {
  const RideProcessingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Text(
              "Waiting for User",
              style: Styles.displayLargeBoldStyle,
            ),
          ),
          const Center(
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
