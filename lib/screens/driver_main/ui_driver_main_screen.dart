import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_tour/common/resources/app_theme/theme_provider.dart';
import 'package:ease_tour/common/widgets/appBar/app_bar.dart';
import 'package:ease_tour/common/widgets/button/app_icon_button.dart';
import 'package:ease_tour/common/widgets/button/app_small_text_button.dart';
import 'package:ease_tour/common/widgets/button/app_text_button.dart';
import 'package:ease_tour/common/widgets/textFields/app_text_field.dart';
import 'package:ease_tour/screens/driver_main/driver_main_screen_view_model.dart';
import 'package:ease_tour/screens/driver_main/widgets/providers/user_destination_provider.dart';
import 'package:ease_tour/screens/driver_main/widgets/providers/user_location_provider.dart';
import 'package:ease_tour/screens/role/providers/role_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart' as pv;
import 'package:stacked/stacked.dart';

import '../../common/resources/constants/styles.dart';

class DriverMainScreen extends StackedView<DriverMainScreenViewModel> {
  const DriverMainScreen({super.key});

  @override
  Widget builder(BuildContext context, DriverMainScreenViewModel viewModel,
      Widget? child) {
    return pv.Consumer(
      builder: (context, ThemeProvider provider, child) {
        return WillPop(
          viewModel: viewModel,
        );
      },
    );
  }

  @override
  DriverMainScreenViewModel viewModelBuilder(BuildContext context) {
    DriverMainScreenViewModel driverMainScreenModel =
        DriverMainScreenViewModel();
    driverMainScreenModel.getUserLocation();
    driverMainScreenModel.getUsersBidding(Get.arguments[0]);
    return driverMainScreenModel;
  }
}

class WillPop extends ConsumerWidget {
  const WillPop({super.key, required this.viewModel});
  final DriverMainScreenViewModel viewModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = viewModel.ridesData;

    int bid = 0;

    if (data.isNotEmpty) {
      bid = data["rides"]["bid_amount"];
    }

    if (viewModel.updateRequired) {
      viewModel.updateUserLocationLatLng(ref);
    }
    if (viewModel.currentLocation != null) {
      viewModel.updateUserLocation(
          FirebaseAuth.instance.currentUser!.uid,
          viewModel.currentLocation!.latitude,
          viewModel.currentLocation!.longitude);
    }

    return WillPopScope(
      onWillPop: () async => viewModel.onWillPop(),
      child: Scaffold(
        floatingActionButton: FloatingActionButton.small(
          onPressed: viewModel.resetCurrentLocation,
          backgroundColor: Styles.buttonColorPrimary,
          child: const Icon(Icons.gps_fixed),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        resizeToAvoidBottomInset: false,
        backgroundColor: Styles.backgroundColor,
        appBar: EtAppBar(
          height: 90,
          color: Styles.trans,
        ),
        drawer: SafeArea(
          child: drawerElement(context, ref),
        ),
        body: Stack(
          children: [
            GoogleMap(
              zoomControlsEnabled: false,
              initialCameraPosition: viewModel.currentLocation != null
                  ? CameraPosition(target: viewModel.currentLocation!, zoom: 14)
                  : CameraPosition(target: viewModel.defaultLocation, zoom: 5),
              onMapCreated: (controller) => viewModel.setController(controller),
              markers: viewModel.markers,
              polylines: viewModel.polylines,
            ),
            viewModel.rideToStart
                ? const SizedBox()
                : Positioned(
                    bottom: viewModel.isCustomBidPressed ? 200 : 90,
                    left: viewModel.isCustomBidPressed ? 0 : 15,
                    right: viewModel.isCustomBidPressed ? 0 : 15,
                    child: viewModel.isCustomBidPressed
                        ? Container(
                            width: double.infinity,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  AppTextField(
                                    label: "Your Bid",
                                    keyboardType: TextInputType.number,
                                    controller: viewModel.controller,
                                    validator: (value) {
                                      if (value != null) {
                                        return "Please provide your bid";
                                      }
                                      return "";
                                    },
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  const Divider(
                                    color: Colors.white,
                                    thickness: 0.5,
                                  ),
                                  const SizedBox(
                                    height: 13,
                                  ),
                                  Center(
                                    child: Text(
                                      "Offer a Reasonable Price",
                                      style:
                                          Styles.displayXXSLightStyle.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 14,
                                  ),
                                  AppTextButton(
                                    text: "Offer",
                                    onTap: () {
                                      if (viewModel
                                          .controller.text.isNotEmpty) {
                                        bid = int.parse(
                                            viewModel.controller.text);
                                        viewModel.addDriverToUserArray(
                                          Get.arguments[0],
                                          FirebaseAuth
                                              .instance.currentUser!.uid,
                                          bid,
                                        );
                                      }
                                    },
                                    color: Styles.primaryColor,
                                  ),
                                  const SizedBox(
                                    height: 14,
                                  ),
                                  AppTextButton(
                                    text: "Close",
                                    onTap: () {},
                                    color: Colors.grey,
                                    borderColor: Styles.primaryColor,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              showDestination(context, viewModel, ref, bid),
                              const SizedBox(
                                height: 20,
                              ),
                              AppTextButton(
                                text: "Accept for $bid",
                                onTap: () async {
                                  viewModel.addDriverToUserArray(
                                      Get.arguments[0],
                                      FirebaseAuth.instance.currentUser!.uid,
                                      bid);

                                  final rideStarted = await Get.toNamed(
                                      '/ride_processing_screen',
                                      arguments: [
                                        FirebaseAuth.instance.currentUser!.uid
                                      ]);
                                  viewModel.ridetoStart(rideStarted);
                                },
                                color: Styles.primaryColor,
                              ),
                              const SizedBox(
                                height: 11,
                              ),
                              Center(
                                child: Text(
                                  "Offer your fare",
                                  style: Styles.displaySmBoldStyle,
                                ),
                              ),
                              const SizedBox(
                                height: 17,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  AppSmallTextButton(
                                    text: "Rs ${bid + 100}",
                                    onTap: () async {
                                      bid = bid + 100;
                                      viewModel.addDriverToUserArray(
                                          Get.arguments[0],
                                          FirebaseAuth
                                              .instance.currentUser!.uid,
                                          bid);

                                      final rideStarted = await Get.toNamed(
                                          '/ride_processing_screen',
                                          arguments: [
                                            FirebaseAuth
                                                .instance.currentUser!.uid
                                          ]);
                                      viewModel.ridetoStart(rideStarted);
                                    },
                                    color: Styles.primaryColor,
                                    width: 77,
                                    height: 41,
                                  ),
                                  AppSmallTextButton(
                                    text: "Rs ${bid + 200}",
                                    onTap: () async {
                                      bid = bid + 200;
                                      viewModel.addDriverToUserArray(
                                          Get.arguments[0],
                                          FirebaseAuth
                                              .instance.currentUser!.uid,
                                          bid);
                                      final rideStarted = await Get.toNamed(
                                          '/ride_processing_screen',
                                          arguments: [
                                            FirebaseAuth
                                                .instance.currentUser!.uid
                                          ]);
                                      viewModel.ridetoStart(rideStarted);
                                    },
                                    color: Styles.primaryColor,
                                    width: 77,
                                    height: 41,
                                  ),
                                  Container(
                                    width: 77,
                                    height: 41,
                                    decoration: BoxDecoration(
                                      color: Styles.primaryColor,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 0.5,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: AppIconButton(
                                      onTap: viewModel.customBid,
                                      color: Styles.primaryColor,
                                      icon: const Icon(
                                        Icons.create_outlined,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                  ),
            viewModel.rideToStart
                ? Positioned(
                    bottom: 10,
                    right: 15,
                    left: 15,
                    child: AppTextButton(
                      text: "End Ride",
                      onTap: () {
                        final userRef = FirebaseDatabase.instance.ref().child(
                            '/drivers/${FirebaseAuth.instance.currentUser!.uid}');
                        userRef.update(
                          {
                            'rideConfirmed': false,
                          },
                        );
                        final userReference =
                            FirebaseDatabase.instance.ref().child('/drivers');
                        Stream stream = userReference.onValue;
                        stream.listen((event) {
                          final driverList = event.snapshot.value;
                          for (int i = 0; i < driverList.length; i++) {
                            final userRef = FirebaseDatabase.instance
                                .ref()
                                .child(
                                    '/drivers/${driverList.keys.elementAt(i)}');
                            userRef.update(
                              {
                                'noLuck': false,
                              },
                            );
                          }
                        });
                        print(Get.arguments[0]);
                        final usersRef = FirebaseDatabase.instance
                            .ref()
                            .child('/users/${Get.arguments[0]}');

                        usersRef.update({'rideFinished': true});
                      },
                      color: Styles.primaryColor,
                    ),
                  )
                : viewModel.isCustomBidPressed
                    ? Container()
                    : Positioned(
                        bottom: 10,
                        right: 15,
                        left: 15,
                        child: AppTextButton(
                          text: "Close",
                          onTap: () {
                            Get.toNamed('/driver_incoming_rides');
                          },
                          color: Styles.primaryColor,
                        ),
                      )
          ],
        ),
      ),
    );
  }

  Drawer drawerElement(BuildContext context, WidgetRef ref) {
    final role = ref.read(roleProvider.notifier).state;
    return Drawer(
      backgroundColor: Styles.backgroundColor,
      // width: MediaQuery.of(context).size.width / 1.7,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), bottomRight: Radius.circular(80)),
      ),
      child: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection(role)
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Show loading indicator while fetching data.
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            final userData = snapshot.data?.data() as Map<String, dynamic>;

            return ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(
                  height: 20,
                ),
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Styles.backgroundColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset('assets/images/userDefault.jpg'),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        userData['full_name'],
                        style: Styles.displayLargeNormalStyle,
                      ),
                      Text(
                        userData['email'],
                        style: Styles.displayXSLightStyle,
                      ),
                    ],
                  ),
                ),
                ListTile(
                  visualDensity:
                      const VisualDensity(horizontal: 0, vertical: -4),
                  leading: Icon(
                    Icons.logout,
                    size: 25,
                    color: Styles.primaryTextColor,
                  ),
                  title: Text(
                    'Logout',
                    style: Styles.displayMedNormalStyle
                        .copyWith(color: Styles.primaryTextColor),
                  ),
                  onTap: viewModel.onLogout,
                ),
                Divider(
                  color: Styles.primaryTextColor,
                ),
              ],
            );
          } else {
            return const Text('No data available');
          }
        },
      ),
    );
  }
}

Container showDestination(BuildContext context,
    DriverMainScreenViewModel viewModel, WidgetRef ref, int bid) {
  final userLocation = ref.read(userLocationProvider.notifier).state;
  final userDestination = ref.read(userDestinationProvider.notifier).state;

  return Container(
    width: MediaQuery.of(context).size.width,
    padding: const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
    decoration: BoxDecoration(
      color: Styles.backgroundColor,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text("Total Distance: ${viewModel.distanceInKiloMeters} km"),
        Consumer(
          builder: (context, ref, child) {
            return Text(
              "Offer: Rs $bid",
              style: Styles.displaySmNormalStyle.copyWith(
                  color: const Color.fromRGBO(135, 6, 46, 100), fontSize: 14),
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SvgPicture.asset('assets/icons/marker_1.svg'),
                const SizedBox(
                  height: 8,
                ),
                SvgPicture.asset('assets/icons/lines_3.svg'),
                const SizedBox(
                  height: 8,
                ),
                SvgPicture.asset('assets/icons/marker_2.svg'),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userLocation,
                  style: Styles.displayXSBoldStyle.copyWith(
                    color: Styles.primaryTextColor,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  height: 2,
                  width: MediaQuery.of(context).size.width / 2,
                  color: Styles.separatorColor,
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  userDestination,
                  style: Styles.displayXSBoldStyle.copyWith(
                    color: Styles.secondryTextColor,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: viewModel.onCrossTap,
              child: SvgPicture.asset('assets/icons/cross.svg'),
            ),
          ],
        ),
      ],
    ),
  );
}
