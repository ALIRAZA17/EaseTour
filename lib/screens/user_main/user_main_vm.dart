import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:ease_tour/common/resources/constants/others.dart';
import 'package:ease_tour/common/resources/constants/styles.dart';
import 'package:ease_tour/common/widgets/button/multi_button.dart';
import 'package:ease_tour/screens/user_main/providers/bid_amount_provider.dart';
import 'package:ease_tour/screens/user_main/providers/driver_location.dart';
import 'package:ease_tour/screens/user_main/providers/update_location_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart' as pp;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  double pricePerKm = 100;
  Map<dynamic, dynamic> driversData = {};
  bool allowMapClick = true;
  bool updateLocation = true;
  int counter = 0;
  bool resetDriverProvider = false;

  dynamic inviteeId;

  LatLng? friendLocation;
  LatLng? driverLocation;

  bool rideFinished = false;

  int count = 0;

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
    try {
      GeolocatorPlatform.instance
          .getPositionStream(
              locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 8,
        timeLimit: Duration(seconds: 10),
      ))
          .listen(
        (position) {
          position = position;
          currentLocation = LatLng(position.latitude, position.longitude);
          notifyListeners();
        },
      );
    } catch (e) {
      updateLocation = false;
      debugPrint('$e');
    }
  }

  getToPreviousScreen() {
    final userRef = FirebaseDatabase.instance
        .ref("users/${FirebaseAuth.instance.currentUser!.uid}");
    Stream stream = userRef.onValue;
    stream.listen((event) async {
      final rideIsCompleted = event.snapshot.value;
      if (rideIsCompleted['rideFinished'] != null) {
        rideFinished = rideIsCompleted['rideFinished'];
        if (rideFinished) {
          selectedLocation = null;
          confirmPressed = false;
          resetDriverProvider = true;

          destinationAddress = 'Enter Your Destination';
          polylines.clear();
          markers.clear();
          polylinesPoints = [];
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
          // Future(() {
          notifyListeners();
          // });

          counter = 0;
          resetDriverProvider = true;

          userRef.update({
            "rideFinished": false,
          });
        }
      }
    });
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
    // ref.read(driversLocationProvider.notifier).state = null;

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
      components: [
        Component(Component.country, 'pk'),
      ],
    );
    displayPredictions(p, ref);
    allowMapClick = false;
    notifyListeners();
  }

  setCurrentLocation(BuildContext context, WidgetRef ref) async {
    polylines.clear();
    markers.clear();
    polylinesPoints = [];
    currentAddress = 'Your Location';
    _distanceInKiloMeters = 0;
    money = 0;

    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: apiKey,
      onError: (error) => onPlaceError(error),
      mode: Mode.overlay,
      language: 'en',
      strictbounds: false,
      types: [""],
      components: [
        Component(Component.country, 'pk'),
      ],
    );

    userDisplayPredictions(p, ref);
    notifyListeners();
  }

  onPlaceError(PlacesAutocompleteResponse error) {
    Get.snackbar('Error', error.errorMessage!);
    debugPrint('Error in Places !!!!!!!!!!');
  }

  void resetCurrentLocation() async {
    var position = await GeolocatorPlatform.instance.getCurrentPosition();
    allowMapClick = true;

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
    GeoData data = await Geocoder2.getDataFromCoordinates(
        latitude: location!.latitude,
        longitude: location.longitude,
        googleMapApiKey: apiKey);
    return '${data.address.split(',')[1]}, ${data.address.split(',')[2]}';
  }

  void onMapTap(LatLng location) {
    if (allowMapClick) {
      currentLocation = location;
      notifyListeners();
      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
            CameraPosition(target: location, zoom: 17)),
      );
    }

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

    notifyListeners();
  }

  void onCrossTap() {
    showDes = false;
    notifyListeners();
  }

  void onConfirmTap(WidgetRef ref, UserMainViewModel userMainViewModel) async {
    confirmPressed = true;
    userMainViewModel.getUsersBidding(FirebaseAuth.instance.currentUser!.uid);
    await saveUserDesAndBid(
        FirebaseAuth.instance.currentUser!.uid,
        selectedLocation!.latitude,
        selectedLocation!.longitude,
        money,
        destinationAddress);
  }

  Future<void> displayPredictions(Prediction? p, WidgetRef ref) async {
    if (p != null) {
      GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: apiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders(),
      );

      PlacesDetailsResponse detail =
          await places.getDetailsByPlaceId(p.placeId!);
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
    }

    notifyListeners();
  }

  Future<void> userDisplayPredictions(Prediction? p, WidgetRef ref) async {
    if (p != null) {
      GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: apiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders(),
      );

      PlacesDetailsResponse detail =
          await places.getDetailsByPlaceId(p.placeId!);
      currentLocation = LatLng(detail.result.geometry!.location.lat,
          detail.result.geometry!.location.lng);
      markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: currentLocation!,
          draggable: true,
          onDragEnd: (location) => onDragEnd(location),
          icon: markerIcon,
        ),
      );

      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
            CameraPosition(target: currentLocation!, zoom: 17)),
      );
      currentAddress = await _getAddressFromLatLng(currentLocation);
    }

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

  _getPolylineInvite(LatLng? currentLocation, LatLng? selectedLocation) async {
    pp.PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      apiKey,
      pp.PointLatLng(currentLocation!.latitude, currentLocation.longitude),
      pp.PointLatLng(selectedLocation!.latitude, selectedLocation.longitude),
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
    money = money + 1;

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
    // updateLocation = false;
  }

  Future<void> saveUserDesAndBid(String userId, double latitude,
      double longitude, int bid, String desAddress) async {
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

  getUsersBidding(dynamic userId) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("users/$userId/driversList");
    Stream stream = ref.onValue;
    stream.listen((event) {
      final rides = event.snapshot.value;
      if (rides == null) {
        driversData = {};
      } else {
        driversData = rides;
      }

      notifyListeners();
    });
  }

  getInvites(dynamic userId, context, title, message) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("users/$userId/invites");
    Stream stream = ref.onValue;
    stream.listen((event) {
      final invites = event.snapshot.value;
      if (invites == null) {
      } else {
        inviteeId = invites['requested_by'];
        if (count == 0) {
          showWarningAlert(context,
              title: title,
              message: message,
              enableCancelButton: true,
              okButtonLabel: 'Accept', onConfirm: () async {
            DatabaseReference ref =
                FirebaseDatabase.instance.ref("users/$inviteeId/location");
            Stream stream = ref.onValue;
            stream.listen((event) async {
              final locations = event.snapshot.value;
              friendLocation =
                  LatLng(locations['latitude'], locations['longitude']);
              driverLocation =
                  LatLng(locations['driver_lat'], locations['driver_long']);

              polylines.clear();
              markers.clear();
              polylinesPoints = [];
              Get.back();

              if (currentLocation != null) {
                markers.add(
                  Marker(
                    markerId: const MarkerId('maker'),
                    position: friendLocation!,
                    draggable: true,
                    onDragEnd: (location) => onDragEnd(location),
                    icon: markerIcon,
                  ),
                );
                markers.add(
                  Marker(
                    markerId: const MarkerId('destination'),
                    position: driverLocation!,
                    icon: markerIcon,
                  ),
                );

                await _getPolylineInvite(friendLocation, driverLocation);

                mapController?.animateCamera(
                  CameraUpdate.newLatLngBounds(
                    LatLngBounds(
                      southwest: LatLng(friendLocation!.latitude - 0.05,
                          friendLocation!.longitude - 0.05),
                      northeast: LatLng(driverLocation!.latitude + 0.05,
                          driverLocation!.longitude + 0.05),
                    ),
                    0,
                  ),
                );
              }
              count++;
              notifyListeners();
            });
            final userLocationRef = FirebaseDatabase.instance.ref().child(
                '/users/${FirebaseAuth.instance.currentUser!.uid}/invites');
            userLocationRef.remove();
          });
        }
      }

      notifyListeners();
    });
  }

  Future<void> updateUserBid(String userId, int bid) async {
    final userLocationRef =
        FirebaseDatabase.instance.ref().child('/users/$userId/rides');
    await userLocationRef.update({
      'bid_amount': bid,
    });
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

  void updatedSelectedLocation(
    WidgetRef ref,
  ) async {
    resetDriverProvider = ref.read(updateProvider);
    if (!resetDriverProvider) {
      selectedLocation = ref.watch(driversLocationProvider);
      polylines.clear();
      markers.clear();
      polylinesPoints = [];
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
        markers.add(
          Marker(
            markerId: const MarkerId('destination'),
            position: selectedLocation!,
            icon: markerIcon,
          ),
        );

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
      }
      counter++;
      notifyListeners();
      Future(() => ref.read(updateProvider.notifier).state = true);
    } else {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        ref.read(driversLocationProvider.notifier).state = null;
      });
    }
  }

  void onInviteFriend() {
    Get.toNamed('/invite_friends');
  }

  void showInvites(BuildContext context, title, message) {}

  showWarningAlert(BuildContext context,
      {required String title,
      required String message,
      String? okButtonLabel,
      VoidCallback? onCancel,
      bool enableCancelButton = false,
      VoidCallback? onConfirm}) {
    return _showCustomAlert(
      context,
      title: title,
      message: message,
      okButtonLabel: okButtonLabel ?? 'Yes',
      onCancel: onCancel,
      enableCancelButton: enableCancelButton,
      onConfirm: onConfirm,
    );
  }

  _showCustomAlert(
    context, {
    required String title,
    required String message,
    String? icon,
    bool enableCancelButton = false,
    Color? okButtonColor,
    String okButtonLabel = 'Ok',
    String cancelButtonLabel = 'Cancel',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        insetPadding: const EdgeInsets.all(16),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            icon != null ? const Icon(Icons.abc_sharp) : const SizedBox(),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              //     style: CHIStyles.lgMediumStyle)
              // .tr(),
            )
          ],
        ),
        content: Builder(builder: (context) {
          return SizedBox(
              width: MediaQuery.of(context).size.shortestSide,
              child: Text(
                message,
                textAlign: TextAlign.center,
                // style: CHIStyles.smNormalStyle
                // .copyWith(color: const Color(0xff667085))
              )
              // .tr(),
              );
        }),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: MultiButton(
              verticalPad: 20,
              btnLabel: okButtonLabel,
              expanded: true,
              color: okButtonColor,
              onTap: onConfirm ?? () => Navigator.pop(context),
            ),
          ),
          SizedBox(height: enableCancelButton ? 12 : 16),
          Visibility(
            visible: enableCancelButton,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: GestureDetector(
                onTap: onCancel ?? () => Navigator.pop(context),
                child: SizedBox(
                    height: 48,
                    child: Text(
                      cancelButtonLabel,
                      // style: CHIStyles.mdMediumStyle,
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
