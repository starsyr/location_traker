import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../helpers/location_helper.dart';
import '../model/user.dart';
import '../services/location_service.dart';


class UserLocationPage extends ConsumerStatefulWidget {
  final UserModel user;

  const UserLocationPage({super.key, required this.user});

  @override
  ConsumerState createState() => _UserLocationPageState();
}

class _UserLocationPageState extends ConsumerState<UserLocationPage>  {

  Timer? _timer;

  double? _lat;
  double? _lng;

  @override
  void initState() {
    super.initState();
    final location = widget.user.location.firstWhere((e){
      final date = (e['date'] as Timestamp).toDate();
      return DateTime.now().isAfter(date);
    });
    _lat = location['lat'];
    _lng = location['lng'];
    _runTimer();
  }

  void _runTimer() {
    final inCircle = LocationHelper.isWithinCircle(
      _lat!,
      _lng!,
    );
    if (!inCircle) {
      if (_timer == null) {
          print("sssssssssssssssssssssssssssssss");
        _timer = Timer(const Duration(seconds: 5), () {
          LocationService.userLocationStream(widget.user.id).listen((value){
            final location = widget.user.location.firstWhere((e){
              final date = (e['date'] as Timestamp).toDate();
              return DateTime.now().isAfter(date);
            });
            final inCircle = LocationHelper.isWithinCircle(
              location['lat'],
              location['lng'],
            );
            if(!inCircle){
              showDialog(context: context, builder: (context){
                return AlertDialog(
                  title: const Text("Uyarı"),
                  content: Text("5 dakadan falzla ${value.name} alan dışındasın"),
                );
              });
            }
          });
        });
      } else {}
    }
  }


  @override
  Widget build(BuildContext context) {
    final inCircle = LocationHelper.isWithinCircle(
      _lat!,
      _lng!,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.name),
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
                  radius: LocationHelper.circleRadius,
                  circleId: const CircleId("redCircle"),
                  center: LocationHelper.circleCenter,
                ),
              },
              markers: {
                Marker(
                  markerId: const MarkerId("me"),
                  icon: BitmapDescriptor.defaultMarker,
                  position: LatLng(
                    _lat!,
                    _lng!,
                  ),
                ),
              },
              initialCameraPosition: CameraPosition(
                zoom: 15,
                target: LatLng(
                  _lat!,
                  _lng!,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
