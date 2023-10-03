import 'package:ease_tour/common/resources/app_theme/theme_provider.dart';
import 'package:ease_tour/common/resources/constants/styles.dart';
import 'package:ease_tour/screens/user_main/driver_select/driver_select_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart' as pv;
import 'package:stacked/stacked.dart';

class DriverSelectView extends StackedView<DriverSelectViewModel> {
  const DriverSelectView({
    super.key,
    required this.driversList,
    required this.bid,
    required this.destinationAddress,
    required this.latitude,
    required this.longitude,
  });
  final Map<dynamic, dynamic> driversList;
  final int bid;
  final String destinationAddress;
  final double latitude;
  final double longitude;

  @override
  Widget builder(
      BuildContext context, DriverSelectViewModel viewModel, Widget? child) {
    return pv.Consumer(builder: (context, ThemeProvider provider, child) {
      if (viewModel.changeBid) {
        viewModel.setBid(bid);
      }

      return MainWidget(
        viewModel: viewModel,
        driversList: driversList,
        bid: bid,
        destinationAddress: destinationAddress,
        latitude: latitude,
        longitude: longitude,
      );
    });
  }

  @override
  DriverSelectViewModel viewModelBuilder(BuildContext context) {
    return DriverSelectViewModel();
  }
}

class MainWidget extends ConsumerWidget {
  const MainWidget({
    super.key,
    required this.viewModel,
    required this.driversList,
    required this.bid,
    required this.destinationAddress,
    required this.latitude,
    required this.longitude,
  });
  final DriverSelectViewModel viewModel;
  final Map<dynamic, dynamic> driversList;
  final int bid;
  final String destinationAddress;
  final double latitude;
  final double longitude;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      viewModel.changeScreenBool
          ? const SizedBox()
          : container1(context, viewModel, driversList),
      const SizedBox(
        height: 15,
      ),
      container2(context, viewModel),
      const SizedBox(
        height: 15,
      ),
      viewModel.changeScreenBool
          ? const SizedBox()
          : GestureDetector(
              onTap: () => viewModel.initiateRide(
                  latitude, longitude, viewModel.bid, destinationAddress, ref),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
                // height: 48,
                decoration: BoxDecoration(
                  color: Styles.buttonColorPrimary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3.5,
                      child: Column(
                        children: [
                          Text(
                            'Total',
                            style: Styles.displayXXXSLightStyle
                                .copyWith(color: Styles.primaryButtonTextColor),
                            // textAlign: TextAlign.center,
                          ),
                          Text(
                            viewModel.bid.toString(),
                            style: Styles.displaySmBoldStyle
                                .copyWith(color: Styles.primaryButtonTextColor),
                            // textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 35,
                      color: Styles.primaryTextColor,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Book Now',
                              style: Styles.displayXMBoldStyle.copyWith(
                                  color: Styles.primaryButtonTextColor),
                            ),
                            SvgPicture.asset('assets/icons/for_arrow.svg'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
    ]);
  }
}

Container container2(BuildContext context, DriverSelectViewModel viewModel) {
  return Container(
    width: MediaQuery.of(context).size.width,
    padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width / 5,
        right: MediaQuery.of(context).size.width / 5,
        top: 20,
        bottom: 20),
    decoration: BoxDecoration(
      color: Styles.backgroundColor,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: viewModel.onPaymentClicked,
          child: Column(
            children: [
              SvgPicture.asset('assets/icons/credit_card.svg'),
              Text(
                'Payment',
                style: Styles.displayXXXSLightStyle,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: viewModel.onShareClicked,
          child: Column(
            children: [
              SvgPicture.asset('assets/icons/friends.svg'),
              Text(
                'Payment',
                style: Styles.displayXXXSLightStyle,
              )
            ],
          ),
        ),
      ],
    ),
  );
}

Container container1(BuildContext context, DriverSelectViewModel viewModel,
    Map<dynamic, dynamic> driversList) {
  return driversList.isEmpty
      ? Container(
          // height: MediaQuery.of(context).size.height / 5,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Styles.backgroundColor,
            border: Border.all(color: Styles.primaryColor, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            'Searching For A Driver...',
            style: Styles.displayLargeNormalStyle,
          ),
        )
      : Container(
          height: MediaQuery.of(context).size.height / 3.8,
          width: MediaQuery.of(context).size.width,
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
          decoration: BoxDecoration(
            color: Styles.backgroundColor,
            border: Border.all(color: Styles.primaryColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SvgPicture.asset('assets/icons/rectangle.svg'),
                ListView.builder(
                  padding: const EdgeInsets.only(top: 20),
                  itemCount: driversList.keys.length,
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    viewModel.getDriverData(driversList.keys.elementAt(index));

                    return GestureDetector(
                      onTap: () {
                        viewModel.onDriverSelect(
                            driversList.keys.elementAt(index), driversList);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: viewModel.elementSelected
                              ? BoxDecoration(
                                  border: Border.all(
                                      color: Styles.primaryColor, width: 1),
                                  borderRadius: BorderRadius.circular(8))
                              : const BoxDecoration(),
                          child: Row(
                            children: [
                              Container(
                                width: 56,
                                height: 75,
                                decoration: BoxDecoration(
                                  color: Styles.primaryColor,
                                  border:
                                      Border.all(color: Styles.primaryColor),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    viewModel.driverName,
                                    style: Styles.displayMedBoldStyle,
                                  ),
                                  Text(
                                    viewModel.driverCar,
                                    style: Styles.displayXSLightStyle,
                                  ),
                                  Text(
                                    viewModel.vehicleNumber,
                                    style: Styles.displayXXSLightStyle,
                                  ),
                                  Text(
                                    '5 min',
                                    style: Styles.displayXSBoldStyle.copyWith(
                                        color: Styles.secondryTextColor),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Text(
                                driversList[driversList.keys.elementAt(index)]
                                        ['bid']
                                    .toString(),
                                style: Styles.displayXSBoldStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        );
}
