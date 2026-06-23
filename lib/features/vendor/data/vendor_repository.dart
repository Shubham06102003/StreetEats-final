import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VendorRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>?> getVendorProfile() async {
    final user = auth.currentUser;

    if (user == null) return null;

    final doc = await firestore.collection('vendors').doc(user.uid).get();

    return doc.data();
  }

  Future<bool> isLocationConfigured() async {
    final vendor = await getVendorProfile();

    return vendor?['isLocationSet'] == true;
  }
}
