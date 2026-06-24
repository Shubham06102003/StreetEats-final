import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> toggleFavorite(String vendorId) async {
    final user = auth.currentUser;

    if (user == null) return;

    final docRef = firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(vendorId);

    final doc = await docRef.get();

    if (doc.exists) {
      await docRef.delete();
    } else {
      await docRef.set({
        'vendorId': vendorId,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await firestore.collection('analytics_events').add({
        'eventType': 'vendor_favorite',
        'vendorId': vendorId,
        'userId': user.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getFavorites() {
    final user = auth.currentUser;

    return firestore
        .collection('users')
        .doc(user!.uid)
        .collection('favorites')
        .snapshots();
  }

  Stream<bool> isFavorite(String vendorId) {
    final user = auth.currentUser;

    return firestore
        .collection('users')
        .doc(user!.uid)
        .collection('favorites')
        .doc(vendorId)
        .snapshots()
        .map((doc) => doc.exists);
  }
}
