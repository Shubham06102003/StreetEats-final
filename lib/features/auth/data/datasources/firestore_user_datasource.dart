import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreUserDataSource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> createUserProfile({
  required String uid,
  required String email,
}) async {
  print("CREATING FIRESTORE USER");

  await firestore.collection('users').doc(uid).set({
    'uid': uid,
    'email': email,
    'role': 'customer',
    'vendorStatus': 'none',
    'createdAt': FieldValue.serverTimestamp(),
  });

  print("FIRESTORE USER CREATED");
}
}