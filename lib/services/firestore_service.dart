import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location_traker/model/user.dart';

final fireStoreServiceProvider = Provider<FireStoreService>((ref) {
  return FireStoreService();
});

class FireStoreService{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> getUserById(String id) async{
    final doc = await _firestore.collection("users").doc(id).get();
    // print(doc.data());
    return UserModel.fromSnapshot(doc.data()!);
  }

  Future<List<UserModel>> getUsers() async{
    final collection = await _firestore.collection("users").where("isAdmin", isNotEqualTo: true).get();
    final docs = collection.docs;
    return docs.map((e) {
      return UserModel.fromSnapshot(e.data());
    }).toList();
  }


  Future<void> addUserDetails(User user) async{

    _firestore.collection("users").doc(user.uid).set({
      "id": user.uid,
      "isAdmin": false,
      "location": {
        "lat": 37.17717932952694,
        "lng": 33.25266656984743
      },
      "name": user.email!.split("@").first
    });
  }
}