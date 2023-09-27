import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class DriverSelectViewModel extends BaseViewModel {
  String driverName = '';
  String driverCar = '';
  String vehicleNumber = '';
  void onBackPressed() {
    debugPrint('Back Pressed');
  }

  getDriverData(String driverId) async {
    final DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
        .instance
        .collection('drivers')
        .doc(driverId)
        .get();
    final docData = doc.data();
    driverName = docData!['full_name'];
    driverCar = docData['vehicleName'];
    vehicleNumber = docData['vehicalNumber'];
    notifyListeners();
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
