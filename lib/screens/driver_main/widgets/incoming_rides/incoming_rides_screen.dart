import 'package:ease_tour/common/resources/app_theme/theme_provider.dart';
import 'package:ease_tour/common/resources/constants/styles.dart';
import 'package:ease_tour/common/widgets/appBar/app_bar.dart';
import 'package:ease_tour/screens/driver_main/widgets/incoming_rides/incoming_rides_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

class IncomingRides extends StackedView<IncomingRidesViewModel> {
  const IncomingRides({super.key});

  @override
  Widget builder(
      BuildContext context, IncomingRidesViewModel viewModel, Widget? child) {
    return Consumer(builder: (context, ThemeProvider provider, child) {
      return Scaffold(
        appBar: EtAppBar(
          height: 90,
          addBackButton: true,
          onBackPress: viewModel.onBackPressed,
        ),
        body: Column(
          children: [
            Container(
              width: 393,
              height: 155,
              color: Styles.primaryColor,
              child: Center(
                child: Text(
                  'Incoming Rides',
                  style: Styles.displayXlBoldStyle.copyWith(
                      color: Styles.transportSelectContainerColor,
                      fontSize: 36),
                ),
              ),
            ),
            friendsList(),
          ],
        ),
      );
    });
  }

  @override
  IncomingRidesViewModel viewModelBuilder(BuildContext context) {
    return IncomingRidesViewModel();
  }
}

Widget friendsList() {
  return Expanded(
    child: SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
            padding: const EdgeInsets.only(top: 20),
            itemCount: 10,
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                  left: 15,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipOval(
                      child: Container(
                        width: 50,
                        height: 50,
                        color: Styles.primaryColor,
                      ),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(
                          bottom: 20,
                          right: 15,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom:
                                BorderSide(color: Styles.borderColor, width: 3),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Street 6 (Johar town Block F)',
                                  style: Styles.displayXMxtrLightStyle
                                      .copyWith(fontSize: 14),
                                ),
                                Text(
                                  'Iqbal Town to M.A.O',
                                  style: Styles.displayXXXSLightStyle.copyWith(
                                    color: Styles.lightGrayTextColor,
                                    fontSize: 14,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Offer: Rs 209",
                                      style: Styles.displaySmNormalStyle
                                          .copyWith(
                                              color: const Color.fromRGBO(
                                                  135, 6, 46, 100),
                                              fontSize: 14),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Text("-2.1 Km")
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              width: 46.11199951171875,
                              height: 31.154996871948242,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Styles.checkContainerColor),
                              child: Image.asset('assets/icons/tick2.png'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    ),
  );
}
