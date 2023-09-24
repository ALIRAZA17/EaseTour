import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class IncomingRidesViewModel extends BaseViewModel {
  TextEditingController textEditingController = TextEditingController();
  onBackPressed() {
    debugPrint('Back Pressed');
  }

  getUsersBidding() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("users");
    Stream stream = ref.onValue;
    stream.listen((event) {
      final rides = event.snapshot.value;
      debugPrint(
          'Event Type: ==========> ${rides.runtimeType}'); // DatabaseEventType.value;
      debugPrint('Snapshot: =-==========> $rides'); // DataSnapshot
    });
  }
}
