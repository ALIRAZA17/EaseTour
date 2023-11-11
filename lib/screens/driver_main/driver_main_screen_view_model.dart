import 'dart:math';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_tour/common/resources/constants/others.dart';
import 'package:ease_tour/common/resources/constants/styles.dart';
import 'package:ease_tour/screens/driver_main/widgets/providers/user_des_latlng_provider.dart';
import 'package:ease_tour/screens/driver_main/widgets/providers/user_loc_latlng_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart' as pp;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stacked/stacked.dart';

class DriverMainScreenViewModel extends BaseViewModel {
  LatLng? currentLocation;
  LatLng? selectedLocation;
  LatLng defaultLocation = const LatLng(30.3753, 69.3451);
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  final formKey = GlobalKey<FormState>();
  bool isCustomBidPressed = false;
  GoogleMapController? mapController;
  String currentAddress = 'Your Location';
  bool getDestinationCheck = false;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  List<LatLng> polylinesPoints = [];
  pp.PolylinePoints polylinePoints = pp.PolylinePoints();
  String destinationAddress = 'Enter Your Destination';
  final controller = TextEditingController();
  double distanceInKiloMeters = 0;
  double pricePerKm = 200;
  bool allowAnimation = true;
  bool updateRequired = true;
  Map<dynamic, dynamic> ridesData = {};
  bool rideToStart = false;

  ridetoStart(bool rideStarted) async {
    rideToStart = rideStarted;
    notifyListeners();
  }

  addCustomIcon() async {
    final Uint8List marker =
        await getBytesFromAsset('assets/icons/marker_3.png', 100);

    markerIcon = BitmapDescriptor.fromBytes(marker);
    notifyListeners();
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void setController(GoogleMapController controller) {
    mapController = controller;
  }

  void updateUserLocationLatLng(WidgetRef ref) async {
    polylines.clear();
    markers.clear();
    polylinesPoints = [];
    destinationAddress = 'Enter Your Destination';
    distanceInKiloMeters = 0;
    selectedLocation = ref.read(userLocLatLngProvider);
    await addCustomIcon();

    currentLocation = ref.read(userDestLatLngProvider);
    if (currentLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('maker'),
          position: currentLocation!,
          icon: markerIcon,
        ),
      );
    }
    markers.add(
      Marker(
        markerId: const MarkerId('destination'),
        position: selectedLocation!,
        icon: markerIcon,
      ),
    );

    await _getPolyline();

    if (allowAnimation) {
      mapController?.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(currentLocation!.latitude - 0.05,
                currentLocation!.longitude - 0.05),
            northeast: LatLng(selectedLocation!.latitude + 0.05,
                selectedLocation!.longitude + 0.05),
          ),
          0,
        ),
      );
    }
    allowAnimation = false;

    await totalDistance();
    distanceInKiloMeters = distanceInKiloMeters.toPrecision(2);
    GeolocatorPlatform.instance
        .getPositionStream(
            locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 8,
      timeLimit: Duration(minutes: 5),
    ))
        .listen(
      (position) {
        position = position;
        currentLocation = LatLng(position.latitude, position.longitude);
        // updateRequired = true;
        notifyListeners();
      },
    );

    notifyListeners();
  }

  totalDistance() {
    for (var i = 0; i < polylinesPoints.length - 1; i++) {
      distanceInKiloMeters = distanceInKiloMeters +
          calculateDistance(
              polylinesPoints[i].latitude,
              polylinesPoints[i].longitude,
              polylinesPoints[i + 1].latitude,
              polylinesPoints[i + 1].longitude);
    }
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  onPlaceError(PlacesAutocompleteResponse error) {
    Get.snackbar('Error', error.errorMessage!);
  }

  onLogout() async {
    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      Get.toNamed("/role_screen");
    } catch (e) {
      debugPrint("Error logging out: $e");
    }
  }

  void getUserLocation() async {
    await addCustomIcon();
    if (currentLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('maker'),
          position: currentLocation!,
          draggable: true,
          onDragEnd: (location) => onDragEnd(location),
          icon: markerIcon,
        ),
      );
    }
    // updateRequired = true;

    // notifyListeners();
  }

  void resetCurrentLocation() async {
    var position = await GeolocatorPlatform.instance.getCurrentPosition();

    currentLocation = LatLng(position.latitude, position.longitude);
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
          CameraPosition(target: currentLocation!, zoom: 17)
          //17 is new zoom level
          ),
    );
    polylinesPoints = [];
    polylines.clear();
    markers.clear();
    // updateRequired = true;
    markers.add(
      Marker(
        markerId: const MarkerId('location'),
        position: currentLocation!,
        draggable: true,
        onDragEnd: (location) => onDragEnd(location),
        icon: markerIcon,
      ),
    );

    notifyListeners();
  }

  onDragEnd(LatLng loc) {}

  Future<bool> onWillPop() async {
    isCustomBidPressed = false;
    notifyListeners();
    return false;
  }

  void onBackPressed() {
    if (isCustomBidPressed) {
      isCustomBidPressed = false;
    } else {
      isCustomBidPressed = true;
    }
    notifyListeners();
  }

  void onCrossTap() {}

  void onConfirmTap() {
    isCustomBidPressed = true;
    notifyListeners();
  }

  void customBid() {
    if (isCustomBidPressed) {
      isCustomBidPressed = false;
    } else {
      isCustomBidPressed = true;
    }
    notifyListeners();
  }

  Future<void> displayPredictions(Prediction? p) async {
    notifyListeners();
  }

  _addPolyLine() {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Styles.primaryColor, points: polylinesPoints);
    polylines.add(polyline);
  }

  _getPolyline() async {
    pp.PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      apiKey,
      pp.PointLatLng(currentLocation!.latitude, currentLocation!.longitude),
      pp.PointLatLng(selectedLocation!.latitude, selectedLocation!.longitude),
      travelMode: pp.TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylinesPoints.add(LatLng(point.latitude, point.longitude));
      }
    }
    _addPolyLine();
  }

  //--------------->DataBase Operations<-----------------

  Future<void> updateUserLocation(
      String driverId, double latitude, double longitude) async {
    final userLocationRef =
        FirebaseDatabase.instance.ref().child('/drivers/$driverId/location');
    await userLocationRef
        .update({'latitude': latitude, 'longitude': longitude});
  }

  getUsersBidding(dynamic userId) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("users/$userId");

    Stream stream = ref.onValue;
    stream.listen((event) {
      final rides = event.snapshot.value;
      ridesData = rides;

      notifyListeners();
      updateRequired = false;
    });
  }

  addDriverToUserArray(String userId, String driverId, int bid) async {
    final userLocationRef = FirebaseDatabase.instance
        .ref()
        .child('/users/$userId/driversList/$driverId');
    await userLocationRef.update(
      {
        'bid': bid,
      },
    );
  }

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  Future<String> getUserName(String id, String role) async {
    final doc = await FirebaseFirestore.instance.collection(role).doc(id).get();
    final docData = doc.data();
    return docData!['full_name'];
  }

  Future<String> getCurrentUserName(String id, String role) async {
    final doc = await FirebaseFirestore.instance.collection(role).doc(id).get();
    final docData = doc.data();
    return docData!['full_name'];
  }
}
