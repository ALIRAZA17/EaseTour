import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:ease_tour/common/resources/constants/others.dart';
import 'package:ease_tour/common/resources/constants/styles.dart';
import 'package:ease_tour/screens/user_main/providers/bid_amount_provider.dart';
import 'package:ease_tour/screens/user_main/providers/user_uid_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart' as pp;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:stacked/stacked.dart';
import 'package:geocoder2/geocoder2.dart';

class UserMainViewModel extends BaseViewModel {
  LatLng? currentLocation;
  LatLng? selectedLocation;
  LatLng defaultLocation = const LatLng(30.3753, 69.3451);
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  final formKey = GlobalKey<FormState>();
  bool confirmPressed = false;
  GoogleMapController? mapController;
  String currentAddress = 'Your Location';
  bool getDestinationCheck = false;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  List<LatLng> polylinesPoints = [];
  pp.PolylinePoints polylinePoints = pp.PolylinePoints();
  String destinationAddress = 'Enter Your Destination';
  bool showDes = true;
  int money = 0;
  double _distanceInKiloMeters = 0;
  double pricePerKm = 200;

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
        position = position;
        currentLocation = LatLng(position.latitude, position.longitude);
        notifyListeners();
      },
    );
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

  void onGetDestinatation(BuildContext context, WidgetRef ref) async {
    polylines.clear();
    markers.clear();
    polylinesPoints = [];
    destinationAddress = 'Enter Your Destination';
    _distanceInKiloMeters = 0;
    money = 0;
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
      // decoration: InputDecoration(
      //   fillColor: Styles.textFormFieldBackColor,
      //   filled: true,
      //   prefixIcon: Icon(
      //     Icons.search,
      //     color: Styles.primaryButtonTextColor,
      //   ),
      //   border: const OutlineInputBorder(
      //       borderRadius: BorderRadius.all(
      //         Radius.circular(8),
      //       ),
      //       borderSide: BorderSide.none),
      //   isCollapsed: true,
      //   label: Text(
      //     'Search',
      //     style: Styles.displaySmNormalStyle
      //         .copyWith(color: Styles.primaryButtonTextColor),
      //   ),
      // ),
      components: [
        Component(Component.country, 'pk'),
      ],
    );
    displayPredictions(p, ref);
  }

  onPlaceError(PlacesAutocompleteResponse error) {
    Get.snackbar('Error', error.errorMessage!);
    debugPrint('Error in Places !!!!!!!!!!');
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
    destinationAddress = 'Enter Your Destination';
    polylinesPoints = [];
    polylines.clear();
    markers.clear();
    _distanceInKiloMeters = 0;
    money = 0;
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
    confirmPressed = false;
    notifyListeners();
    return false;
  }

  Future<String> _getAddressFromLatLng(LatLng? location) async {
    // await placemarkFromCoordinates(
    //         currentLocation!.latitude, currentLocation!.longitude)
    //     .then((List<Placemark> placemarks) {
    //   Placemark place = placemarks[0];

    //   currentAddress = '${place.subLocality}, ${place.subAdministrativeArea}';
    //   notifyListeners();
    // }).catchError((e) {
    // });
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

  void onActionPressed(BuildContext context) {
    {
      Scaffold.of(context).openDrawer();
    }
    // if (confirmPressed) {
    //   confirmPressed = false;
    // } else {
    //   confirmPressed = true;
    // }

    notifyListeners();
  }

  void onCrossTap() {
    showDes = false;
    notifyListeners();
  }

  void onConfirmTap(WidgetRef ref) {
    confirmPressed = true;
    notifyListeners();
  }

  Future<void> displayPredictions(Prediction? p, WidgetRef ref) async {
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
    totalDistance(ref);
    await saveUserDesAndBid(
        ref.read(userIdProvider),
        selectedLocation!.latitude,
        selectedLocation!.longitude,
        money,
        destinationAddress);

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

  onPlusClicked() {
    money++;
    notifyListeners();
  }

  totalDistance(WidgetRef ref) {
    for (var i = 0; i < polylinesPoints.length - 1; i++) {
      _distanceInKiloMeters += calculateDistance(
          polylinesPoints[i].latitude,
          polylinesPoints[i].longitude,
          polylinesPoints[i + 1].latitude,
          polylinesPoints[i + 1].longitude);
    }
    money = (pricePerKm * _distanceInKiloMeters).round();
    ref.read(moneyProvider.notifier).state = money;

    notifyListeners();
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  onMinusClicked() {
    if (money > 0) {
      money--;
      notifyListeners();
    }
  }

  //--------------->DataBase Operations<-----------------

  Future<void> updateUserLocation(
      String userId, double latitude, double longitude, String address) async {
    final userLocationRef =
        FirebaseDatabase.instance.ref().child('/users/$userId/location');
    await userLocationRef.update(
        {'latitude': latitude, 'longitude': longitude, 'address': address});
  }

  Future<void> saveUserDesAndBid(String userId, double latitude,
      double longitude, int bid, String desAddress) async {
<<<<<<< HEAD
=======
    debugPrint('Updating User Selected Destination and Bid Amount');
>>>>>>> d5347942dfded2199572f55aad17acfe0f420f91
    // Get a reference to the driver's location node in the database.
    final userLocationRef =
        FirebaseDatabase.instance.ref().child('/users/$userId/rides');
    await userLocationRef.update({
      'des_latitude': latitude,
      'des_longitude': longitude,
      'des_address': desAddress,
      'bid_amount': bid,
      'searching': true,
    });
  }

  onLogout() {}
}
