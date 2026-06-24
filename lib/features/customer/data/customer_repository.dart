import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerRepository {
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>>
      getApprovedVendors() {
    return firestore
        .collection('vendors')
        .where(
          'isActive',
          isEqualTo: true,
        )
        .snapshots();
  }

  Future<List<String>> getCategories() async {
    final snapshot =
        await firestore
            .collection('vendors')
            .get();

    final Set<String> categories =
        {'All'};

    for (final doc in snapshot.docs) {
      final data = doc.data();

      if (data['primaryCategory'] != null) {
        categories.add(
          data['primaryCategory'],
        );
      }
    }

    return categories.toList();
  }
}