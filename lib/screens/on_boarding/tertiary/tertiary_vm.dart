import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class TertiaryViewModel extends BaseViewModel {
  void onSkipTap() {
    debugPrint('Skipped');
  }

  void onTapNext() {
    debugPrint('Next is Tapped');
  }
}
