import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../provider/location_provider.dart';
import '../services/location_service.dart';
import '../services/stream_location_service.dart';
import '../widgets/my_app_bar.dart';
import '../widgets/my_drawer.dart';

class HomePage extends ConsumerWidget {
   const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const MyAppBar(
        title: "H O M E",
        actions: [],
      ),
      drawer: const MyDrawer(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Activate this for location follwing"),
              Switch(
                onChanged: (value) async{
                  if(value){
                    final permissionGenerated = await StreamLocationService.askLocationPermission();
                    if(permissionGenerated) {
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
                  }else{
                    final locationStream = ref.read(locationStreamSubscriptionProvider);
                    if(locationStream != null) locationStream.cancel();
                  }
                  ref.read(switchProvider.notifier).state = value;
                },
                value: ref.watch(switchProvider),
              ),
            ],
          )
        ),
      ),
    );
  }
}