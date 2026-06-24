import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProfileProvider =
    FutureProvider<
        Map<String, dynamic>?>(
  (ref) async {
    final user =
        FirebaseAuth
            .instance
            .currentUser;

    if (user == null) {
      return null;
    }

    final doc =
        await FirebaseFirestore
            .instance
            .collection('users')
            .doc(user.uid)
            .get();

    if (!doc.exists) {
      return {
        'uid': user.uid,
        'email': user.email ?? '',
        'role': 'customer',
        'vendorStatus': 'none',
        'name': '',
        'photoUrl': '',
      };
    }

    return doc.data();
  },
);