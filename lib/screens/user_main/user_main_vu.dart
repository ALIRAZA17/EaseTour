import 'package:ease_tour/common/resources/app_theme/theme_provider.dart';
import 'package:ease_tour/common/widgets/appBar/app_bar.dart';
import 'package:ease_tour/common/widgets/button/action_button.dart';
import 'package:ease_tour/common/widgets/button/multi_button.dart';
import 'package:ease_tour/screens/user_main/driver_select/driver_select_vu.dart';
import 'package:ease_tour/screens/user_main/providers/driver_location.dart';
import 'package:ease_tour/screens/user_main/user_main_vm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart' as pv;
import 'package:stacked/stacked.dart';

import '../../common/resources/constants/styles.dart';

class UserMainView extends StackedView<UserMainViewModel> {
  const UserMainView({super.key});

  @override
  Widget builder(
      BuildContext context, UserMainViewModel viewModel, Widget? child) {
    return pv.Consumer(builder: (builder, ThemeProvider provider, child) {
      return WillPop(viewModel: viewModel);
    });

    // return WillPop(viewModel: viewModel,);
  }

  @override
  UserMainViewModel viewModelBuilder(BuildContext context) {
    UserMainViewModel userMainViewModel = UserMainViewModel();
    userMainViewModel.getUserLocation();
    userMainViewModel.getInvites(FirebaseAuth.instance.currentUser!.uid,
        context, 'Invite From Friend', 'Press Accept to Start Ride');

    return userMainViewModel;
  }
}

class WillPop extends ConsumerWidget {
  const WillPop({
    super.key,
    required this.viewModel,
  });
  final UserMainViewModel viewModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('Being Rebuilt');
    if (viewModel.currentLocation != null) {
      viewModel.updateUserLocation(
          FirebaseAuth.instance.currentUser!.uid,
          viewModel.currentLocation!.latitude,
          viewModel.currentLocation!.longitude,
          viewModel.currentAddress);
    }
    print('Drivers Location Provider: ${ref.read(driversLocationProvider)}');
    if (ref.watch(driversLocationProvider) != null && viewModel.counter == 0) {
      print('Updating Selected Location');
      viewModel.updatedSelectedLocation(ref);
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
          addBackButton: false,
          actions: [
            Builder(builder: (context) {
              return ActionButton(
                icon: 'assets/icons/bars-ver.svg',
                onTap: () => viewModel.onActionPressed(context),
              );
            })
          ],
        ),
        drawer: SafeArea(
          child: drawerElement(context),
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
              onTap: (location) => viewModel.onMapTap(location),
            ),
            Positioned(
              bottom: 30,
              left: 15,
              right: 15,
              child: viewModel.confirmPressed
                  ? DriverSelectView(
                      driversList: viewModel.driversData,
                      bid: viewModel.money,
                      destinationAddress: viewModel.destinationAddress,
                      latitude: viewModel.selectedLocation!.latitude,
                      longitude: viewModel.selectedLocation!.longitude,
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                            onTap: () =>
                                viewModel.onGetDestinatation(context, ref),
                            child: enterDestination(context, viewModel, ref)),
                        const SizedBox(
                          height: 15,
                        ),
                        showDestination(context, viewModel, ref),
                        const SizedBox(
                          height: 15,
                        ),
                        viewModel.destinationAddress != 'Enter Your Destination'
                            ? bidding(context, viewModel)
                            : const SizedBox(),
                        const SizedBox(
                          height: 15,
                        ),
                        viewModel.destinationAddress != 'Enter Your Destination'
                            ? MultiButton(
                                btnLabel: 'Confirm',
                                onTap: () =>
                                    viewModel.onConfirmTap(ref, viewModel),
                                expanded: true,
                                verticalPad: 18,
                              )
                            : const SizedBox()
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Drawer drawerElement(BuildContext context) {
    return Drawer(
      backgroundColor: Styles.backgroundColor,
      // width: MediaQuery.of(context).size.width / 1.7,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), bottomRight: Radius.circular(80)),
      ),
      child: ListView(
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
                  'Nate Samson',
                  style: Styles.displayLargeNormalStyle,
                ),
                Text(
                  'nate@gmail.com',
                  style: Styles.displayXSLightStyle,
                ),
              ],
            ),
          ),
          ListTile(
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            leading: Icon(
              Icons.logout,
              size: 25,
              color: Styles.primaryTextColor,
            ),
            title: Text(
              'History',
              style: Styles.displayMedNormalStyle
                  .copyWith(color: Styles.primaryTextColor),
            ),
            onTap: () {
              Get.toNamed('/history');
            },
          ),
          Divider(
            color: Styles.primaryTextColor,
          ),
          ListTile(
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            leading: Icon(
              Icons.person,
              size: 25,
              color: Styles.primaryTextColor,
            ),
            title: Text(
              'Invite Friend',
              style: Styles.displayMedNormalStyle
                  .copyWith(color: Styles.primaryTextColor),
            ),
            onTap: viewModel.onInviteFriend,
          ),
          Divider(
            color: Styles.primaryTextColor,
          ),
          ListTile(
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            leading: Icon(
              Icons.logout,
              size: 25,
              color: Styles.primaryTextColor,
            ),
            title: Text(
              'Invites',
              style: Styles.displayMedNormalStyle
                  .copyWith(color: Styles.primaryTextColor),
            ),
            onTap: () => viewModel.showInvites(
                context, 'Invite From Friend', 'Press Accept to accept Ride'),
          ),
          Divider(
            color: Styles.primaryTextColor,
          ),
          ListTile(
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
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
      ),
    );
  }
}

Container bidding(BuildContext context, UserMainViewModel viewModel) {
  return Container(
    width: MediaQuery.of(context).size.width,
    padding: const EdgeInsets.only(left: 30, right: 15, top: 5, bottom: 5),
    decoration: BoxDecoration(
      color: Styles.backgroundColor,
      border: Border.all(color: Styles.primaryColor),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        Text(
          'Rs ${viewModel.money}',
          style: Styles.displayLargeNormalStyle,
        ),
        const Spacer(),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Styles.primaryColor,
                border: Border.all(color: Styles.primaryColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                onPressed: viewModel.onPlusClicked,
                icon: const Icon(Icons.add),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Container(
              decoration: BoxDecoration(
                color: Styles.backgroundColor,
                border: Border.all(color: Styles.primaryColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                onPressed: viewModel.onMinusClicked,
                icon: const Icon(Icons.remove),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget enterDestination(
    BuildContext context, UserMainViewModel viewModel, WidgetRef ref) {
  return viewModel.showDes
      ? Container(
          width: MediaQuery.of(context).size.width,
          padding:
              const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
          decoration: BoxDecoration(
            color: Styles.primaryColor,
            border: Border.all(color: Styles.primaryColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter Your Destination',
                    // softWrap: true,
                    overflow: TextOverflow.clip,
                    style: Styles.displayMedBoldStyle.copyWith(
                      color: Styles.primaryButtonTextColor,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Tell Us Wherever to Go',
                    style: Styles.displayXSLightStyle.copyWith(
                      color: Styles.primaryButtonTextColor,
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
        )
      : const SizedBox();
}

Container showDestination(
    BuildContext context, UserMainViewModel viewModel, WidgetRef ref) {
  return Container(
    width: MediaQuery.of(context).size.width,
    padding: const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
    decoration: BoxDecoration(
      color: Styles.backgroundColor,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Row(
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
              viewModel.currentAddress,
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
            GestureDetector(
              onTap: () => viewModel.onGetDestinatation(context, ref),
              child: Text(
                viewModel.destinationAddress,
                style: Styles.displayXSBoldStyle.copyWith(
                  color: Styles.secondryTextColor,
                ),
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
  );
}
