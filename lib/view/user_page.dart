import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../helpers/location_helper.dart';
import '../model/user.dart';
import '../provider/location_provider.dart';
import '../services/location_service.dart';
import '../services/stream_location_service.dart';

class UserPage extends ConsumerStatefulWidget {
  final UserModel user;
  const UserPage({super.key, required this.user});

  @override
  ConsumerState createState() => _UserPageState();
}

class _UserPageState extends ConsumerState<UserPage> {

  Timer? _timer;

  double? _lat;
  double? _lng;

  @override
  void initState() {
    final location = widget.user.location.firstWhere((e){
      final date = (e['date'] as Timestamp).toDate();
      return DateTime.now().isAfter(date);
    });
    _lat = location['lat'];
    _lng = location['lng'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Activate this for location follwing"),
            Switch(
              onChanged: (value) async {
                if (value) {
                  await StreamLocationService.askLocationPermission().then((permissionGenerated){
                    if (permissionGenerated) {
                      _timer ??= _runTimer(context);
                      ref.read(locationStreamSubscriptionProvider.notifier).state =
                          StreamLocationService.onLocationChanged?.listen(
                                (position) async {
                              print("listennnn");
                              await LocationService.updateUserLocation(
                                FirebaseAuth.instance.currentUser!.uid,
                                LatLng(position.latitude, position.longitude),
                              );
                            },
                          );
                    }
                  });
                } else {
                  final locationStream = ref.read(locationStreamSubscriptionProvider);
                  if (locationStream != null) locationStream.cancel();
                  _timer?.cancel();
                  _timer = null;
                }
                ref.read(switchProvider.notifier).state = value;
              },
              value: ref.watch(switchProvider),
            ),
          ],
        ),
      ),
    );
  }

  Timer? _runTimer(BuildContext context) {
    Timer? timer;
    final inCircle = LocationHelper.isWithinCircle(
      _lat!,
      _lng!,
    );
    if (!inCircle) {
      print("sssssssssssssssssssssssssssssss");
      timer = Timer(const Duration(seconds: 5), () {
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
    }
    return timer;
  }
}