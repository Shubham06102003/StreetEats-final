import 'package:cloud_firestore/cloud_firestore.dart';

class VendorDetailsRepository {
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  Future<DocumentSnapshot<Map<String, dynamic>>>
      getVendor(String vendorId) {
    return firestore
        .collection('vendors')
        .doc(vendorId)
        .get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>
      getVendorMenu(String vendorId) {
    return firestore
        .collection('menu_items')
        .where(
          'vendorId',
          isEqualTo: vendorId,
        )
        .where(
          'isAvailable',
          isEqualTo: true,
        )
        .snapshots();
  }
}