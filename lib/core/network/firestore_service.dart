import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> createUser({
    required String uid,
    required String email,
    required String role,
  }) async {
    await firestore.collection('users').doc(uid).set({
      'uid': uid,
      'email': email,
      'role': role,
      'name': '',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}