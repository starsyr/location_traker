import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';


final locationStreamSubscriptionProvider = StateProvider<StreamSubscription<Position>?>((ref) {
  return ;
});

final switchProvider = StateProvider<bool>((ref) {
  return false;
});
