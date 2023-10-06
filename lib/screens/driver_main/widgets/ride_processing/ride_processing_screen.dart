import 'package:ease_tour/common/resources/constants/styles.dart';
import 'package:ease_tour/common/widgets/button/app_text_button.dart';
import 'package:ease_tour/screens/driver_main/widgets/ride_processing/ride_processing_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

class RideProcessingScreen extends StackedView<RideProcessingScreenViewModel> {
  const RideProcessingScreen({super.key});

  @override
  Widget builder(BuildContext context, RideProcessingScreenViewModel viewModel,
      Widget? child) {
    if (viewModel.noUserConfirmation) {
      SchedulerBinding.instance.addPostFrameCallback((dr) {
        Get.offAllNamed('/driver_incoming_rides');
      });
    } else {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              viewModel.userConfirmation
                  ? Text(
                      "The User Has Confirmed your ride",
                      style: Styles.displayLargeBoldStyle,
                    )
                  : Text(
                      "Waiting For User",
                      style: Styles.displayLargeBoldStyle,
                    ),
              const SizedBox(
                height: 20,
              ),
              viewModel.userConfirmation
                  ? AppTextButton(
                      text: "Start Ride",
                      onTap: () {
                        Navigator.of(context).pop(true);
                      },
                      color: Styles.primaryColor)
                  : const CircularProgressIndicator(),
            ],
          ),
        ),
      );
    }

    return Container();
  }

  @override
  RideProcessingScreenViewModel viewModelBuilder(BuildContext context) {
    RideProcessingScreenViewModel viewmodel = RideProcessingScreenViewModel();
    viewmodel.driverConfirmation(Get.arguments[0]);
    return viewmodel;
  }
}
