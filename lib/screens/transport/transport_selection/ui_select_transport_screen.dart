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
              height: 30,
            ),
            Center(
              child: Text(
                "Select your transport",
                style: Styles.displayXlBoldStyle.copyWith(
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              children: [
                TransportOptionsContainer(
                  image: "Car.jpg",
                  title: "Car",
                  onTap: () {
                    Get.toNamed('/signup');
                  },
                ),
                const SizedBox(
                  width: 20,
                ),
                TransportOptionsContainer(
                  image: "Bike.jpg",
                  title: "Bike",
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
                  image: "Cycle.jpg",
                  title: "Cycle",
                  onTap: () {},
                ),
                const SizedBox(
                  width: 20,
                ),
                TransportOptionsContainer(
                  image: "Taxi.jpg",
                  title: "Taxi",
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
