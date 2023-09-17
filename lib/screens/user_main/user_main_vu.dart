import 'package:ease_tour/common/resources/app_theme/theme_provider.dart';
import 'package:ease_tour/common/widgets/appBar/app_bar.dart';
import 'package:ease_tour/common/widgets/button/multi_button.dart';
import 'package:ease_tour/screens/user_main/driver_select/driver_select_vu.dart';
import 'package:ease_tour/screens/user_main/user_main_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

import '../../common/resources/constants/styles.dart';

class UserMainView extends StackedView<UserMainViewModel> {
  const UserMainView({super.key});

  @override
  Widget builder(
      BuildContext context, UserMainViewModel viewModel, Widget? child) {
    return Consumer(
      builder: (context, ThemeProvider provider, child) {
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
              addBackButton: true,
              onBackPress: viewModel.onBackPressed,
            ),
            body: Stack(
              children: [
                GoogleMap(
                  zoomControlsEnabled: false,
                  initialCameraPosition: viewModel.currentLocation != null
                      ? CameraPosition(
                          target: viewModel.currentLocation!, zoom: 14)
                      : CameraPosition(
                          target: viewModel.defaultLocation, zoom: 5),
                  onMapCreated: (controller) =>
                      viewModel.setController(controller),
                  markers: viewModel.currentLocation != null
                      ? {
                          Marker(
                            markerId: const MarkerId('maker'),
                            position: viewModel.currentLocation!,
                            draggable: true,
                            onDragEnd: (location) =>
                                viewModel.onDragEnd(location),
                            icon: viewModel.markerIcon,
                          ),
                        }
                      : {},
                  onTap: (location) => viewModel.onMapTap(location),
                ),
                Positioned(
                  bottom: 30,
                  left: 15,
                  right: 15,
                  child: viewModel.confirmPressed
                      ? const DriverSelectView()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            enterDestination(context, viewModel),
                            const SizedBox(
                              height: 15,
                            ),
                            showDestination(context, viewModel),
                            const SizedBox(
                              height: 15,
                            ),
                            MultiButton(
                              btnLabel: 'Confirm',
                              onTap: viewModel.onConfirmTap,
                              expanded: true,
                              verticalPad: 18,
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  UserMainViewModel viewModelBuilder(BuildContext context) {
    UserMainViewModel userMainViewModel = UserMainViewModel();
    userMainViewModel.getUserLocation();
    return userMainViewModel;
  }
}

Container enterDestination(BuildContext context, UserMainViewModel viewModel) {
  return Container(
    width: MediaQuery.of(context).size.width,
    padding: const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
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
  );
}

Container showDestination(BuildContext context, UserMainViewModel viewModel) {
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
            Text(
              'Enter your destination',
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
  );
}
