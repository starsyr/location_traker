import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  final user = ref.watch(userLoginRequestProvider);
  if(user == null) throw("User email and password must not be null");

  return FirebaseAuth.instance.createUserWithEmailAndPassword(email: user.usr, password: user.pwd);
});


final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});


final logoutProvider = FutureProvider<void>((ref) async {
  return FirebaseAuth.instance.signOut();
});