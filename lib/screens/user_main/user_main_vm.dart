import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';

class UserMainViewModel extends BaseViewModel {
  LatLng? currentLocation;
  LatLng defaultLocation = const LatLng(30.3753, 69.3451);
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  final formKey = GlobalKey<FormState>();
  bool confirmPressed = false;
  GoogleMapController? mapController;
  String currentAddress = 'Address';

  void addCustomIcon() async {
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

  void getUserLocation() async {
    var position = await GeolocatorPlatform.instance.getCurrentPosition();

    currentLocation = LatLng(position.latitude, position.longitude);
    addCustomIcon();
    if (currentLocation != null) {
      mapController?.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: currentLocation!, zoom: 17)
          //17 is new zoom level
          ));
      await _getAddressFromLatLng();
      print(currentAddress);
    }
    notifyListeners();
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

    notifyListeners();
  }

  onDragEnd(LatLng loc) {}

  Future<bool> onWillPop() async {
    confirmPressed = false;
    notifyListeners();
    return false;
  }

  Future<void> _getAddressFromLatLng() async {
    print(currentLocation);
    await placemarkFromCoordinates(
            currentLocation!.latitude, currentLocation!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];

      currentAddress = '${place.subLocality}, ${place.subAdministrativeArea}';
      print(currentAddress);
      notifyListeners();
    }).catchError((e) {
      debugPrint(e);
    });
  }

  void onMapTap(LatLng location) {
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: location, zoom: 17)
          //17 is new zoom level
          ),
    );
    currentLocation = location;
    notifyListeners();
  }

  void onBackPressed() {
    if (confirmPressed) {
      confirmPressed = false;
    } else {
      confirmPressed = true;
    }
    notifyListeners();
    debugPrint('Back Pressed');
  }

  void onCrossTap() {
    debugPrint('Crossed');
  }

  void onConfirmTap() {
    debugPrint('Confirm Pressed');
    confirmPressed = true;
    notifyListeners();
  }
}
