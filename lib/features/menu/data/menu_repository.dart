import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MenuRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> addMenuItem({
    required String name,
    required String menuCategory,
    required String description,
    required int basePrice,
    required String imageUrl,
  }) async {
    final user = auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    await firestore.collection('menu_items').add({
      'vendorId': user.uid,
      'name': name,
      'menuCategory': menuCategory,
      'description': description,
      'basePrice': basePrice,
      'imageUrl': imageUrl,
      'isAvailable': true,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getVendorMenuItems() {
    final user = auth.currentUser;

    return firestore
        .collection('menu_items')
        .where('vendorId', isEqualTo: user?.uid)
        .snapshots();
  }

  Future<void> deleteMenuItem(String menuItemId) async {
    await firestore.collection('menu_items').doc(menuItemId).delete();
  }

  Future<void> updateAvailability({
    required String menuItemId,
    required bool isAvailable,
  }) async {
    await firestore.collection('menu_items').doc(menuItemId).update({
      'isAvailable': isAvailable,
    });
  }

  Future<void> updateMenuItem({
    required String menuItemId,
    required String name,
    required String menuCategory,
    required String description,
    required int basePrice,
  }) async {
    await firestore.collection('menu_items').doc(menuItemId).update({
      'name': name,
      'menuCategory': menuCategory,
      'description': description,
      'basePrice': basePrice,
    });
  }
}
