import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../common/resources/constants/bottom_navbar_consts.dart';

class BottomNavViewModel extends BaseViewModel {
  List<Widget> widgetList = widgetsList;
  int index = 0;

  void onActionTapped() {
    debugPrint('Action Button Pressed');
  }

  void onLeadingPressed() {
    debugPrint('Leading Button Pressed');
  }

  List<String> iconsList() {
    return iconsListNav;
  }

  List<String> labelList() {
    return labelListNav;
  }

  onNavBarItemChange(int ind) {
    index = ind;
    notifyListeners();
  }
}
