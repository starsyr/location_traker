import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location_traker/model/user.dart';
import 'package:location_traker/services/firestore_service.dart';

final userProvider = FutureProvider.family<UserModel, String>((ref, id) async {
  return ref.read(fireStoreServiceProvider).getUserById(id);
});

final usersProvider = FutureProvider<List<UserModel>>((ref) async {
  return ref.read(fireStoreServiceProvider).getUsers();
});