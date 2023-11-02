import 'package:ease_tour/common/resources/app_theme/theme_provider.dart';
import 'package:ease_tour/common/resources/constants/styles.dart';
import 'package:ease_tour/common/widgets/appBar/app_bar.dart';
import 'package:ease_tour/screens/driver_main/widgets/incoming_rides/incoming_rides_view_model.dart';
import 'package:ease_tour/screens/driver_main/widgets/providers/user_destination_provider.dart';
import 'package:ease_tour/screens/driver_main/widgets/providers/user_loc_latlng_provider.dart';
import 'package:ease_tour/screens/driver_main/widgets/providers/user_location_provider.dart';
import 'package:ease_tour/screens/user_main/providers/user_uid_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart' as pv;
import 'package:stacked/stacked.dart';

class IncomingRides extends StackedView<IncomingRidesViewModel> {
  const IncomingRides({super.key});

  @override
  Widget builder(
      BuildContext context, IncomingRidesViewModel viewModel, Widget? child) {
    return pv.Consumer(builder: (context, ThemeProvider provider, child) {
      return IncomingRidesData(
        viewModel: viewModel,
      );
    });
  }

  @override
  IncomingRidesViewModel viewModelBuilder(BuildContext context) {
    IncomingRidesViewModel incomingRidesViewModel = IncomingRidesViewModel();
    incomingRidesViewModel.getUsersBidding();
    return incomingRidesViewModel;
  }
}

class IncomingRidesData extends ConsumerWidget {
  const IncomingRidesData({super.key, required this.viewModel});

  final IncomingRidesViewModel viewModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    color: Styles.transportSelectContainerColor, fontSize: 36),
              ),
            ),
          ),
          friendsList(viewModel, ref),
        ],
      ),
    );
  }
}

Widget friendsList(
    IncomingRidesViewModel incomingRidesViewModel, WidgetRef ref) {
  final ridesData = incomingRidesViewModel.ridesData;

  return Expanded(
    child: SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
            padding: const EdgeInsets.only(top: 20),
            itemCount: ridesData.keys.length,
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final userAddress = ridesData.values
                  .elementAt(index)["location"]["address"]
                  .toString();

              final userDestinationAddress = ridesData.values
                  .elementAt(index)["rides"]["des_address"]
                  .toString();
              final bid = ridesData.values
                  .elementAt(index)["rides"]["bid_amount"]
                  .toString();
              final userId = ridesData.keys.elementAt(index).toString();

              final userIdToBeSent = ridesData.keys.elementAt(index);

              final userLocation = LatLng(
                  ridesData.values.elementAt(index)["location"]["latitude"],
                  ridesData.values.elementAt(index)["location"]["longitude"]);
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
                                FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    userDestinationAddress,
                                    style: Styles.displayXMxtrLightStyle
                                        .copyWith(fontSize: 12),
                                  ),
                                ),
                                FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    userAddress,
                                    style:
                                        Styles.displayXXXSLightStyle.copyWith(
                                      color: Styles.lightGrayTextColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Offers $bid",
                                      style: Styles.displaySmNormalStyle
                                          .copyWith(
                                              color: const Color.fromRGBO(
                                                  135, 6, 46, 100),
                                              fontSize: 12),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                ref.read(userIdProvider.notifier).state =
                                    userId;
                                ref
                                    .read(userDestinationProvider.notifier)
                                    .state = userDestinationAddress;
                                ref.read(userLocationProvider.notifier).state =
                                    userAddress;

                                ref.read(userLocLatLngProvider.notifier).state =
                                    userLocation;

                                Get.toNamed('/driver_main_screen',
                                    arguments: [userIdToBeSent]);
                              },
                              child: Container(
                                width: 46.11199951171875,
                                height: 31.154996871948242,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Styles.checkContainerColor),
                                child: Image.asset('assets/icons/tick2.png'),
                              ),
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
