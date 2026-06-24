import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AnalyticsRepository {
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth auth =
      FirebaseAuth.instance;

  Future<void> trackEvent({
    required String eventType,
    required String vendorId,
  }) async {
    final user = auth.currentUser;

    await firestore
        .collection('analytics_events')
        .add({
      'eventType': eventType,
      'vendorId': vendorId,
      'userId': user?.uid,
      'timestamp':
          FieldValue.serverTimestamp(),
    });
  }
}