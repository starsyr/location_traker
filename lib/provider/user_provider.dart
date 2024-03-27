import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location_traker/model/user.dart';
import 'package:location_traker/services/firestore_service.dart';

final userProvider = FutureProvider<UserModel>((ref) async {
  final id = FirebaseAuth.instance.currentUser?.uid;

  ref.read(fireStoreServiceProvider).getUsers();

  return ref.read(fireStoreServiceProvider).getUserById(id!);
});
