import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_tour/screens/user_main/providers/driver_location.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';

class DriverSelectViewModel extends BaseViewModel {
  String driverName = '';
  String driverCar = '';
  String vehicleNumber = '';
  bool elementSelected = false;
  int bid = 0;
  bool changeBid = true;
  String? selectedDriverId;
  bool changeScreenBool = false;
  LatLng? driversLocation;
  var driverData = [];
  var listDriver = {};

  int? selectedIndex;

  void onBackPressed() {
    debugPrint('Back Pressed');
  }

  void setBid(int money) {
    changeBid = false;
    bid = money;
  }

  getDriverData(String driverId, driversList) async {
    listDriver = driversList;
    final DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
        .instance
        .collection('drivers')
        .doc(driverId)
        .get();
    final docData = doc.data();
    driverName = docData!['full_name'];
    driverCar = docData['vehicleName'];
    vehicleNumber = docData['vehicalNumber'];
    driverData.add({
      'driverName': driverName,
      'driverCar': driverCar,
      'vehicleNumber': vehicleNumber,
    });

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

  void onDriverSelect(
      String driverId, Map<dynamic, dynamic> driversList, int index) {
    elementSelected = true;
    selectedIndex = index;
    bid = driversList[driverId]['bid'];
    selectedDriverId = driverId;
    notifyListeners();
  }

  void initiateRide(double latitude, double longitude, int bid,
      String desAddress, WidgetRef ref, Map<dynamic, dynamic> driverList) {
    updateScreen();
    createHistory(FirebaseAuth.instance.currentUser!.uid, latitude, longitude,
        bid, desAddress, selectedDriverId!);
    final userRef =
        FirebaseDatabase.instance.ref().child('/drivers/$selectedDriverId');
    userRef.update(
      {
        'rideConfirmed': true,
      },
    );

    getDriverLocation(selectedDriverId!, ref);

    resetBid(FirebaseAuth.instance.currentUser!.uid);
    removeDriversList(FirebaseAuth.instance.currentUser!.uid);
    for (int i = 0; i < driverList.length; i++) {
      if (driverList.keys.elementAt(i) != selectedDriverId) {
        final userRef = FirebaseDatabase.instance
            .ref()
            .child('/drivers/${driverList.keys.elementAt(i)}');
        userRef.update(
          {
            'noLuck': true,
          },
        );
      }
    }
    notifyListeners();
  }

  updateScreen() {
    changeScreenBool = true;
    notifyListeners();
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

  void getDriverLocation(String driverId, WidgetRef reference) {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("drivers/$driverId/location");

    Stream stream = ref.onValue;
    stream.listen((event) {
      final loactionsData = event.snapshot.value;
      driversLocation =
          LatLng(loactionsData['latitude'], loactionsData['longitude']);
      reference.watch(driversLocationProvider.notifier).state = driversLocation;
      final refer = FirebaseDatabase.instance
          .ref()
          .child('/users/${FirebaseAuth.instance.currentUser!.uid}/location');
      refer.update(
        {
          'driver_lat': driversLocation!.latitude,
          'driver_long': driversLocation!.longitude,
        },
      );
    });
    // notifyListeners();
  }
}
