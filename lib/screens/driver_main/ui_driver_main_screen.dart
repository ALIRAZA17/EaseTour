import 'package:ease_tour/common/resources/app_theme/theme_provider.dart';
import 'package:ease_tour/common/widgets/appBar/app_bar.dart';
import 'package:ease_tour/common/widgets/button/app_small_text_button.dart';
import 'package:ease_tour/common/widgets/button/app_text_button.dart';
import 'package:ease_tour/screens/driver_main/driver_main_screen_view_model.dart';
import 'package:ease_tour/screens/user_main/driver_select/driver_select_vu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

import '../../common/resources/constants/styles.dart';

class DriverMainScreen extends StackedView<DriverMainScreenViewModel> {
  const DriverMainScreen({super.key});

  @override
  Widget builder(BuildContext context, DriverMainScreenViewModel viewModel,
      Widget? child) {
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
                  markers: viewModel.markers,
                  polylines: viewModel.polylines,
                  onTap: (location) => viewModel.onMapTap(location),
                ),
                Positioned(
                  bottom: 90,
                  left: 15,
                  right: 15,
                  child: viewModel.confirmPressed
                      ? const DriverSelectView()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            showDestination(context, viewModel),
                            const SizedBox(
                              height: 20,
                            ),
                            AppTextButton(
                              text: "Accept for 209",
                              onTap: () {},
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                AppSmallTextButton(
                                  text: "Rs 209",
                                  onTap: () {},
                                  color: Styles.primaryColor,
                                  width: 77,
                                  height: 41,
                                ),
                                AppSmallTextButton(
                                  text: "Rs 209",
                                  onTap: () {},
                                  color: Styles.primaryColor,
                                  width: 77,
                                  height: 41,
                                ),
                                AppSmallTextButton(
                                  text: "Rs 209",
                                  onTap: () {},
                                  color: Styles.primaryColor,
                                  width: 77,
                                  height: 41,
                                ),
                              ],
                            )
                          ],
                        ),
                ),
                Positioned(
                  bottom: 10,
                  right: 15,
                  left: 15,
                  child: AppTextButton(
                    text: "Close",
                    onTap: () {},
                    color: Styles.primaryColor,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  DriverMainScreenViewModel viewModelBuilder(BuildContext context) {
    DriverMainScreenViewModel driverMainScreenModel =
        DriverMainScreenViewModel();
    driverMainScreenModel.getUserLocation();
    return driverMainScreenModel;
  }
}

Container showDestination(
    BuildContext context, DriverMainScreenViewModel viewModel) {
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
        const Text("Total Distance: 2.1 km"),
        Text(
          "Offer: Rs 209",
          style: Styles.displaySmNormalStyle.copyWith(
              color: const Color.fromRGBO(135, 6, 46, 100), fontSize: 14),
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
                  viewModel.destinationAddress,
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
