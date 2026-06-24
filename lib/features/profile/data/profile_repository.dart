import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileRepository {
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth auth =
      FirebaseAuth.instance;

  Future<void> updateProfile({
    required String name,
    required String photoUrl,
  }) async {
    final user = auth.currentUser;

    if (user == null) return;

    await firestore
        .collection('users')
        .doc(user.uid)
        .set({
      'name': name,
      'photoUrl': photoUrl,
      'updatedAt':
          FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}