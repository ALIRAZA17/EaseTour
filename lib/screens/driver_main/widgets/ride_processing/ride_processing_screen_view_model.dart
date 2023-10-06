import 'package:firebase_database/firebase_database.dart';
import 'package:stacked/stacked.dart';

class RideProcessingScreenViewModel extends BaseViewModel {
  Map<dynamic, dynamic> ridesData = {};

  bool userConfirmation = false;
  bool noUserConfirmation = false;
  driverConfirmation(dynamic driverId) async {
    print('Driver Confirmation');
    DatabaseReference ref = FirebaseDatabase.instance.ref("drivers/$driverId");

    Stream stream = ref.onValue;
    stream.listen((event) {
      final rides = event.snapshot.value;
      if (rides['rideConfirmed'] != null) {
        userConfirmation = rides['rideConfirmed'];
      }
      if (rides['noLuck'] != null) {
        noUserConfirmation = rides['noLuck'];
      }

      print('userConfirmation : $userConfirmation');
      print('userConfirmation : $noUserConfirmation');
      notifyListeners();
    });
  }
}
