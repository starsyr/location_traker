import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../model/user.dart';

class UserLocationPage extends StatelessWidget {
  final UserModel user;

  const UserLocationPage({super.key, required this.user});

  final LatLng circleCenter = const LatLng(37.1771148, 33.2525056);
  final double circleRadius = 15;

  bool isWithinCircle(double lat1, double lon1, double lat2, double lon2, double radius) {
    double distance = haversineDistance(lat1, lon1, lat2, lon2);
    return distance <= radius;
  }

  double haversineDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371000; // Radius of the Earth in meters
    final dLat = (lat2 - lat1) * (3.141592653589793 / 180.0);
    final dLon = (lon2 - lon1) * (3.141592653589793 / 180.0);
    final a = 0.5 -
        cos(dLat) / 2 +
        cos(lat1 * (3.141592653589793 / 180.0)) * cos(lat2 * (3.141592653589793 / 180.0)) * (1 - cos(dLon)) / 2;
    return R * 2 * asin(sqrt(a));
  }

  @override
  Widget build(BuildContext context) {
    final inCircle = isWithinCircle(
      user.location['lat'],
      user.location['lng'],
      circleCenter.latitude,
      circleCenter.longitude,
      circleRadius,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: inCircle ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5.0),
            child: Text(
              inCircle ? "Alan içi" : "Alan dışı",
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: GoogleMap(
              circles: {
                Circle(
                  fillColor: Colors.red.withOpacity(0.5),
                  strokeWidth: 0,
                  radius: circleRadius,
                  circleId: const CircleId("redCircle"),
                  center: circleCenter,
                ),
              },
              markers: {
                Marker(
                  markerId: const MarkerId("me"),
                  icon: BitmapDescriptor.defaultMarker,
                  position: LatLng(
                    user.location['lat'],
                    user.location['lng'],
                  ),
                ),
              },
              initialCameraPosition: CameraPosition(
                zoom: 15,
                target: LatLng(
                  user.location['lat'],
                  user.location['lng'],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
