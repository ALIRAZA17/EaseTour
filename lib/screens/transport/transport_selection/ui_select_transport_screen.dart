import 'package:ease_tour/common/resources/constants/styles.dart';
import 'package:ease_tour/common/widgets/appBar/app_bar.dart';
import 'package:ease_tour/screens/transport/transport_selection/widgets/transport_options_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectTransportScreen extends StatelessWidget {
  const SelectTransportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EtAppBar(
        title: "Select transport",
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
                      "WeGo",
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
                "Suggestions",
                style: Styles.displayXlBoldStyle
                    .copyWith(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              children: [
                TransportOptionsContainer(
                  image: "car.png",
                  title: "Car Mini",
                  onTap: () {
                    Get.toNamed('/signup');
                  },
                ),
                const SizedBox(
                  width: 20,
                ),
                TransportOptionsContainer(
                  image: "car.png",
                  title: "Car AC",
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                TransportOptionsContainer(
                  image: "rikshaw.png",
                  title: "Rikshaw",
                  onTap: () {},
                ),
                const SizedBox(
                  width: 20,
                ),
                TransportOptionsContainer(
                  image: "bike.png",
                  title: "Bike",
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
