import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_traker/model/user.dart';

class LocationService{
  static final _firestore = FirebaseFirestore.instance;

  static Future<void> updateUserLocation(String userId, LatLng location) async {
    try {
      print("objecttt");
      await _firestore.collection('users').doc(userId).update({
        'location': FieldValue.arrayUnion([{'lat': location.latitude, 'lng': location.longitude, "date": Timestamp.now()}]),
      });
    } on FirebaseException catch (e) {
      print('Ann error due to firebase occured $e');
    } catch (err) {
      print('Ann error occured $err');
    }
  }

  static Stream<List<UserModel>> userCollectionStream() {
    return _firestore.collection('users').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => UserModel.fromSnapshot(doc.data())).toList());
  }

  static Stream<UserModel> userLocationStream(String id) {
    return _firestore.collection('users').doc(id).snapshots().map((snapshot) => UserModel.fromSnapshot(snapshot.data()!));
  }
}