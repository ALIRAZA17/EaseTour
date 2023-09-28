import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class DriverSelectViewModel extends BaseViewModel {
  String driverName = '';
  String driverCar = '';
  String vehicleNumber = '';
  bool elementSelected = false;
  int bid = 0;
  bool changeBid = true;
  String? selectedDriverId;

  void onBackPressed() {
    debugPrint('Back Pressed');
  }

  void setBid(int money) {
    changeBid = false;
    bid = money;
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

  void onDriverSelect(String driverId, Map<dynamic, dynamic> driversList) {
    elementSelected = true;
    bid = driversList[driverId]['bid'];
    selectedDriverId = driverId;
    notifyListeners();
  }

  void initiateRide(
      double latitude, double longitude, int bid, String desAddress) {
    createHistory(FirebaseAuth.instance.currentUser!.uid, latitude, longitude,
        bid, desAddress, selectedDriverId!);
    resetBid(FirebaseAuth.instance.currentUser!.uid);
    removeDriversList(FirebaseAuth.instance.currentUser!.uid);
  }

  Future<void> createHistory(String userId, double latitude, double longitude,
      int bid, String desAddress, String driverId) async {
    // Get a reference to the driver's location node in the database.
    final userRef =
        FirebaseDatabase.instance.ref().child('/users/$userId/history');
    userRef.push().set({
      'driver_id': driverId,
      'des_latitude': latitude,
      'des_longitude': longitude,
      'des_address': desAddress,
      'bid_amount': bid,
    });
  }

  Future<void> removeDriversList(String userId) async {
    // Get a reference to the driver's location node in the database.
    final userRef =
        FirebaseDatabase.instance.ref().child('/users/$userId/driversList');
    await userRef.remove();
  }

  void resetBid(String userId) async {
    final userLocationRef =
        FirebaseDatabase.instance.ref().child('/users/$userId/rides');
    await userLocationRef.update({
      'des_latitude': 0,
      'des_longitude': 0,
      'des_address': 'desAddress',
      'bid_amount': 0,
      'searching': false,
    });
  }
}
