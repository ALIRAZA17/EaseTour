import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

class HistoryViewModel extends BaseViewModel {
  Map<dynamic, dynamic> historyData = {};

  void onBackPressed() {
    debugPrint('Back Pressed');
    Get.back();
  }

  void history(String userId) {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("users/$userId/history");
    Stream stream = ref.onValue;
    stream.listen((event) {
      final history = event.snapshot.value;
      if (history == null) {
        historyData = {};
      } else {
        historyData = history;
      }

      notifyListeners();
    });
  }

  Future<Map<String, dynamic>> fetchDriverInfo(String driverId) async {
    final DocumentSnapshot driverSnapshot = await FirebaseFirestore.instance
        .collection('drivers')
        .doc(driverId)
        .get();

    if (driverSnapshot.exists) {
      return driverSnapshot.data() as Map<String, dynamic>;
    } else {
      return {}; // Return an empty map if driver not found or an error occurs.
    }
  }
}
