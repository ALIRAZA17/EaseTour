import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

final userIdProvider = StateProvider<String>((ref) => '');
