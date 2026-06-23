import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VendorApplicationRepository {
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth auth =
      FirebaseAuth.instance;

  Future<void> submitApplication({
    required String ownerName,
    required String phoneNumber,
    required String whatsappNumber,
    required String businessName,
    required String state,
    required String city,
    required String operatingArea,
    required String primaryCategory,
    required String secondaryCategory,
    required String openingTime,
    required String closingTime,
    required String instagramUsername,
    required String description,
  }) async {
    final user = auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    await firestore
        .collection('vendor_applications')
        .add({
      'userId': user.uid,
      'email': user.email,

      'ownerName': ownerName,
      'phoneNumber': phoneNumber,
      'whatsappNumber': whatsappNumber,

      'businessName': businessName,

      'state': state,
      'city': city,
      'operatingArea': operatingArea,

      'primaryCategory': primaryCategory,
      'secondaryCategory': secondaryCategory,

      'openingTime': openingTime,
      'closingTime': closingTime,

      'instagramUsername': instagramUsername,

      'description': description,

      'status': 'pending',

      'submittedAt': FieldValue.serverTimestamp(),
    });

    await firestore
        .collection('users')
        .doc(user.uid)
        .update({
      'vendorStatus': 'pending',
    });
  }
}