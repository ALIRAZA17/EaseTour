import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class PickupViewModel extends BaseViewModel {
  TextEditingController textEditingController = TextEditingController();
  onBackPressed() {
    debugPrint('Back Pressed');
  }
}
