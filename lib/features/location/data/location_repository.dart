import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LocationRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> saveVendorLocation({
    required double latitude,
    required double longitude,
    required String address,
    required String landmark,
  }) async {
    final user = auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    await firestore.collection('vendors').doc(user.uid).set({
      'latitude': latitude,
      'longitude': longitude,

      'address': address,
      'landmark': landmark,

      'isLocationSet': true,

      'locationUpdatedAt': FieldValue.serverTimestamp(),
    });
  }
}
