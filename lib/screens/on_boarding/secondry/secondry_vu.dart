import 'package:ease_tour/common/resources/constants/padding.dart';
import 'package:ease_tour/common/resources/constants/styles.dart';
import 'package:ease_tour/common/widgets/appBar/app_bar.dart';
import 'package:ease_tour/screens/on_boarding/secondry/secondry_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

import '../../../common/resources/app_theme/theme_provider.dart';

class SecondryView extends StackedView<SecondryViewModel> {
  const SecondryView({super.key});

  @override
  Widget builder(
      BuildContext context, SecondryViewModel viewModel, Widget? child) {
    return Consumer(
      builder: (context, ThemeProvider provider, child) {
        return Scaffold(
          appBar: EtAppBar(
            color: Styles.trans,
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
          ),
          body: Padding(
            padding: Pads.primaryPaddingHor,
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                SvgPicture.asset('assets/images/secondry_onBoarding.svg'),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  'At Anytime',
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
                  child: Image.asset('assets/images/loader_2.png'),
                ),
                const SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  SecondryViewModel viewModelBuilder(BuildContext context) {
    return SecondryViewModel();
  }
}
