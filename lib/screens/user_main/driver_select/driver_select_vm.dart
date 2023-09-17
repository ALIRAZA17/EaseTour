import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class DriverSelectViewModel extends BaseViewModel {
  void onBackPressed() {
    debugPrint('Back Pressed');
  }

  void onCrossTap() {
    debugPrint('Crossed');
  }

  void onBookTap() {
    debugPrint('Confirm Pressed');
  }

  void onPaymentClicked() {
    debugPrint('Payment Clicked');
  }

  void onShareClicked() {
    debugPrint('Share Clicked');
  }
}
