import 'package:ease_tour/common/resources/constants/padding.dart';
import 'package:ease_tour/common/resources/constants/styles.dart';
import 'package:ease_tour/common/widgets/appBar/app_bar.dart';
import 'package:ease_tour/screens/on_boarding/primary/primary_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stacked/stacked.dart';

class PrimaryView extends StackedView<PrimaryViewModel> {
  const PrimaryView({super.key});

  @override
  Widget builder(
      BuildContext context, PrimaryViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: EtAppBar(
        color: Styles.backgroundColor,
        addBackButton: false,
        actions: [
          GestureDetector(
            onTap: viewModel.onSkipTap,
            child: Text(
              'Skip',
              style: Styles.displayMedNormalStyle
                  .copyWith(color: Styles.primaryTextColor),
            ),
          )
        ],
        height: 90,
      ),
      body: Padding(
        padding: Pads.primaryPaddingHor,
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            SvgPicture.asset('assets/images/primary_onboarding.svg'),
            const SizedBox(
              height: 25,
            ),
            Text(
              'Anywhere You Are',
              style: Styles.displayXlNormalStyle
                  .copyWith(color: Styles.primaryTextColor),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 40, right: 40),
              child: Text(
                'Sell houses easily with the help of Listenoryx and to make this line big I am writing more.',
                style: Styles.displaySmNormalStyle
                    .copyWith(color: Styles.secondryTextColor),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 70,
            ),
            const Spacer(),
            GestureDetector(
              onTap: viewModel.onTapNext,
              child: Image.asset('assets/images/loader_1.png'),
            ),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }

  @override
  PrimaryViewModel viewModelBuilder(BuildContext context) {
    return PrimaryViewModel();
  }
}
