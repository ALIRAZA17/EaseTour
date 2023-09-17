import 'package:ease_tour/common/resources/constants/styles.dart';
import 'package:ease_tour/common/widgets/button/app_text_button.dart';
import 'package:ease_tour/screens/home/home_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({super.key});

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: SvgPicture.asset('assets/images/background.svg'),
            ),
            Center(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 6,
                  ),
                  SvgPicture.asset('assets/images/home_img.svg'),
                  SizedBox(height: MediaQuery.of(context).size.height / 7),
                  AppTextButton(
                      text: 'Book Ride',
                      onTap: viewModel.onBookRideTap,
                      color: Styles.buttonColorPrimary)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) {
    return HomeViewModel();
  }
}
