import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileDataSource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getProfile(String uid) async {
    final doc = await firestore.collection('users').doc(uid).get();

    return doc.data();
  }
}