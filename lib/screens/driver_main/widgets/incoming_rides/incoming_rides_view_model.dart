import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class IncomingRidesViewModel extends BaseViewModel {
  TextEditingController textEditingController = TextEditingController();
  Map<dynamic, dynamic> ridesData = {};
  onBackPressed() {
    debugPrint('Back Pressed');
  }

  getUsersBidding() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("users");
    Stream stream = ref.onValue;
    stream.listen((event) {
      final rides = event.snapshot.value;
      ridesData = rides;
      print(ridesData);
      notifyListeners();
    });
  }
}
