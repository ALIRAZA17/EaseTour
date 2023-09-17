import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {
  void onBookRideTap() {
    Get.offAllNamed('/main_screen');
  }
}
