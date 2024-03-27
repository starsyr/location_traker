import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location_traker/services/firestore_service.dart';

import '../model/user_request_model.dart';


final userLoginRequestProvider = StateProvider<UserRequestModel?>((ref) {
  return;
});

final loginProvider = FutureProvider<UserCredential?>((ref) async {
  final user = ref.watch(userLoginRequestProvider);
  if(user == null) throw("User email and password must not be null");

  return FirebaseAuth.instance.signInWithEmailAndPassword(email: user.usr, password: user.pwd);
});


final signupProvider = FutureProvider<UserCredential?>((ref) async {
  final userRequest = ref.watch(userLoginRequestProvider);
  if(userRequest == null) throw("User email and password must not be null");

  final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: userRequest.usr, password: userRequest.pwd);

  ref.read(fireStoreServiceProvider).addUserDetails(userCredential.user!);

  return userCredential;
});


final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});


final logoutProvider = FutureProvider<void>((ref) async {
  return FirebaseAuth.instance.signOut();
});