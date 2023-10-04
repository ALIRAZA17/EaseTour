import 'package:firebase_database/firebase_database.dart';
import 'package:stacked/stacked.dart';

class RideProcessingScreenViewModel extends BaseViewModel {
  Map<dynamic, dynamic> ridesData = {};

  bool userConfirmation = false;
  bool noUserConfirmation = false;
  driverConfirmation(dynamic driverId) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("drivers/$driverId");

    Stream stream = ref.onValue;
    stream.listen((event) {
      final rides = event.snapshot.value;
      userConfirmation = rides['rideConfirmed'];
      noUserConfirmation = rides['noLuck'];
      notifyListeners();
    });
  }
}
