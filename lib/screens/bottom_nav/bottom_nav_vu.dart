import 'package:ease_tour/common/resources/app_theme/theme_provider.dart';
import 'package:ease_tour/common/widgets/bottom_navbar/bottom_navbar.dart';
import 'package:ease_tour/common/widgets/button/action_button.dart';
import 'package:ease_tour/screens/bottom_nav/bottom_nav_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

import '../../common/resources/constants/styles.dart';
import '../../common/widgets/appBar/app_bar.dart';

class BottomNavView extends StackedView<BottomNavViewModel> {
  const BottomNavView({super.key});

  @override
  Widget builder(
      BuildContext context, BottomNavViewModel viewModel, Widget? child) {
    return Consumer(
      builder: (context, ThemeProvider provider, child) {
        return Scaffold(
          backgroundColor: Styles.primaryColorLight,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/hexa.svg',
                height: 70,
                width: 70,
              ),
              SvgPicture.asset('assets/icons/wallet.svg')
            ],
          ),
          appBar: EtAppBar(
            color: Styles.trans,
            addBackButton: false,
            addLeadingButton: true,
            onLeadingPress: viewModel.onLeadingPressed,
            actions: [
              ActionButton(
                icon: 'assets/icons/notification.svg',
                iconColor: Styles.primaryIconColor,
                onTap: viewModel.onActionTapped,
                color: Styles.backgroundColor,
              )
            ],
          ),
          body: IndexedStack(
            index: viewModel.index,
            children: viewModel.widgetList,
          ),
          bottomNavigationBar: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            child: BottomNavigation(
              currentIndex: viewModel.index,
              icons: viewModel.iconsList(),
              labels: viewModel.labelList(),
              itemChanged: (int i) => viewModel.onNavBarItemChange(i),
            ),
          ),
        );
      },
    );
  }

  @override
  BottomNavViewModel viewModelBuilder(BuildContext context) {
    return BottomNavViewModel();
  }
}

class HexaClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(0, size.height / 3);
    path.lineTo(0, size.height / 1.5);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, size.height / 1.5);
    path.lineTo(size.width, size.height / 3);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
