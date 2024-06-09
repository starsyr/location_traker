import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationHelper{
  LocationHelper._();

  static const double circleRadius = 50;
  static const LatLng circleCenter = LatLng(37.1734845, 33.2442112);

  static bool isWithinCircle(double lat1, double lon1) {
    double distance = haversineDistance(lat1, lon1, circleCenter.latitude, circleCenter.longitude);
    return distance <= circleRadius;
  }

  static double haversineDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371000; // Radius of the Earth in meters
    final dLat = (lat2 - lat1) * (3.141592653589793 / 180.0);
    final dLon = (lon2 - lon1) * (3.141592653589793 / 180.0);
    final a = 0.5 -
        cos(dLat) / 2 +
        cos(lat1 * (3.141592653589793 / 180.0)) * cos(lat2 * (3.141592653589793 / 180.0)) * (1 - cos(dLon)) / 2;
    return R * 2 * asin(sqrt(a));
  }
}