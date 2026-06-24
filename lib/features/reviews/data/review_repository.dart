import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReviewRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final FirebaseAuth auth = FirebaseAuth.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getReviews(String vendorId) {
    return firestore
        .collection('vendor_reviews')
        .where('vendorId', isEqualTo: vendorId)
        .snapshots();
  }

  Future<void> addReview({
  required String vendorId,
  required double rating,
  required String review,
}) async {
  final user = auth.currentUser;

  if (user == null) return;

  final userDoc = await firestore
      .collection('users')
      .doc(user.uid)
      .get();

  final userData = userDoc.data();

  await firestore
      .collection('vendor_reviews')
      .add({
    'vendorId': vendorId,
    'userId': user.uid,
    'userName':
        userData?['name'] ??
        'Customer',

    'userPhotoUrl':
        userData?['photoUrl'] ??
        '',

    'rating': rating,
    'review': review,

    'createdAt':
        FieldValue.serverTimestamp(),
  });
}
}
