import 'dart:ui' as ui;
import 'package:ease_tour/common/resources/constants/others.dart';
import 'package:ease_tour/common/resources/constants/styles.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart' as pp;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:stacked/stacked.dart';
import 'package:geocoder2/geocoder2.dart';

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

  void onGetDestinatation(
    BuildContext context,
  ) async {
    polylines.clear();
    markers.clear();
    polylinesPoints = [];
    markers.add(
      Marker(
        markerId: const MarkerId('maker'),
        position: currentLocation!,
        draggable: true,
        onDragEnd: (location) => onDragEnd(location),
        icon: markerIcon,
      ),
    );
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: apiKey,
      onError: (error) => onPlaceError(error),
      mode: Mode.overlay,
      language: 'en',
      strictbounds: false,
      types: [""],
      decoration: InputDecoration(
        fillColor: Styles.textFormFieldBackColor,
        filled: true,
        prefixIcon: Icon(
          Icons.search,
          color: Styles.primaryButtonTextColor,
        ),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
            borderSide: BorderSide.none),
        isCollapsed: true,
        label: Text(
          'Search',
          style: Styles.displaySmNormalStyle
              .copyWith(color: Styles.primaryButtonTextColor),
        ),
      ),
      components: [
        Component(Component.country, 'pk'),
      ],
    );
    displayPredictions(p);
  }

  onPlaceError(PlacesAutocompleteResponse error) {
    Get.snackbar('Error', error.errorMessage!);
    debugPrint('Error in Places !!!!!!!!!!');
  }

  void getUserLocation() async {
    var position = await GeolocatorPlatform.instance.getCurrentPosition();

    currentLocation = LatLng(position.latitude, position.longitude);
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
      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
            CameraPosition(target: currentLocation!, zoom: 17)
            //17 is new zoom level
            ),
      );
      currentAddress = await _getAddressFromLatLng(currentLocation);
    }
    notifyListeners();
    GeolocatorPlatform.instance
        .getPositionStream(
            // locationSettings: const LocationSettings(
            //     accuracy: LocationAccuracy.bestForNavigation,
            //     distanceFilter: 4,
            //     timeLimit: Duration(seconds: 1))
            )
        .listen(
      (position) {
        debugPrint('${position.latitude}');
        position = position;
        currentLocation = LatLng(position.latitude, position.longitude);
        notifyListeners();
      },
    );
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

  Future<String> _getAddressFromLatLng(LatLng? location) async {
    GeoData data = await Geocoder2.getDataFromCoordinates(
        latitude: location!.latitude,
        longitude: location.longitude,
        googleMapApiKey: apiKey);
    return '${data.address.split(',')[1]}, ${data.address.split(',')[2]}';
  }

  void onMapTap(LatLng location) {
    currentLocation = location;
    notifyListeners();
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: location, zoom: 17)
          //17 is new zoom level
          ),
    );

    markers.clear();
    markers.add(
      Marker(
        markerId: const MarkerId('location'),
        position: currentLocation!,
        draggable: true,
        onDragEnd: (location) => onDragEnd(location),
        icon: markerIcon,
      ),
    );
  }

  void onBackPressed() {
    if (isCustomBidPressed) {
      isCustomBidPressed = false;
    } else {
      isCustomBidPressed = true;
    }
    notifyListeners();
    debugPrint('Back Pressed');
  }

  void onCrossTap() {
    debugPrint('Crossed');
  }

  void onConfirmTap() {
    debugPrint('Confirm Pressed');
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
    GoogleMapsPlaces places = GoogleMapsPlaces(
      apiKey: apiKey,
      apiHeaders: await const GoogleApiHeaders().getHeaders(),
    );
    PlacesDetailsResponse detail =
        await places.getDetailsByPlaceId(p!.placeId!);
    selectedLocation = LatLng(detail.result.geometry!.location.lat,
        detail.result.geometry!.location.lng);
    markers.add(
      Marker(
        markerId: const MarkerId('destination'),
        position: selectedLocation!,
        draggable: true,
        onDragEnd: (location) => onDragEnd(location),
        icon: markerIcon,
      ),
    );

    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
          CameraPosition(target: selectedLocation!, zoom: 17)),
    );
    destinationAddress = await _getAddressFromLatLng(selectedLocation);
    await _getPolyline();
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
    debugPrint('Updating Driver Location');
    // Get a reference to the driver's location node in the database.
    final userLocationRef =
        FirebaseDatabase.instance.ref().child('/drivers/$driverId/location');
    await userLocationRef
        .update({'latitude': latitude, 'longitude': longitude});
  }
}
