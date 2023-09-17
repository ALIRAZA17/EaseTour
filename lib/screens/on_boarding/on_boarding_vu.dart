import 'package:drop_shadow_image/drop_shadow_image.dart';
import 'package:ease_tour/common/widgets/appBar/app_bar.dart';
import 'package:ease_tour/screens/on_boarding/on_boarding_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stacked/stacked.dart';

import '../../common/resources/constants/padding.dart';
import '../../common/resources/constants/styles.dart';

class OnBoardingView extends StackedView<OnBoardingViewModel> {
  const OnBoardingView({super.key});

  @override
  Widget builder(
      BuildContext context, OnBoardingViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: EtAppBar(
        height: 90,
        color: Styles.trans,
        addBackButton: false,
        actions: [
          GestureDetector(
            onTap: () => viewModel.changeMode(context),
            child: Text(
              'Skip',
              style: Styles.displayMedNormalStyle
                  .copyWith(color: Styles.primaryTextColor),
            ),
          )
        ],
      ),
      body: Padding(
        padding: Pads.onBoardingPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset('assets/images/onBoarding.svg'),
            DropShadowImage(
              image: Image.asset('assets/images/logo.png'), borderRadius: 20,
              //@blurRadius if not defined default value is
              blurRadius: 0.2,
              //@offset default value is Offset(8,8)
              offset: const Offset(0, 0),
              //@scale if not defined default value is 1
              // scale: 1.05,
              scale: 0,
            ),
            // const Spacer(),
            GestureDetector(
              onTap: viewModel.onTapNext,
              child: Image.asset('assets/images/loader.png'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  OnBoardingViewModel viewModelBuilder(BuildContext context) {
    return OnBoardingViewModel();
  }
}
