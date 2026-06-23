import 'package:cloud_firestore/cloud_firestore.dart';

class AdminRepository {
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>>
      getPendingApplications() {
    return firestore
        .collection('vendor_applications')
        .where('status', isEqualTo: 'pending')
        .snapshots();
  }

  Future<void> approveVendor({
    required String applicationId,
    required String userId,
  }) async {
    await firestore
        .collection('vendor_applications')
        .doc(applicationId)
        .update({
      'status': 'approved',
      'reviewedAt':
          FieldValue.serverTimestamp(),
    });

    await firestore
        .collection('users')
        .doc(userId)
        .update({
      'role': 'vendor',
      'vendorStatus': 'approved',
    });

    final applicationDoc = await firestore
    .collection('vendor_applications')
    .doc(applicationId)
    .get();

final applicationData = applicationDoc.data();

if (applicationData != null) {
  await firestore
      .collection('vendors')
      .doc(userId)
      .set({
    'userId': userId,

    'ownerName':
        applicationData['ownerName'],

    'businessName':
        applicationData['businessName'],

    'phoneNumber':
        applicationData['phoneNumber'],

    'whatsappNumber':
        applicationData['whatsappNumber'],

    'state':
        applicationData['state'],

    'city':
        applicationData['city'],

    'operatingArea':
        applicationData['operatingArea'],

    'primaryCategory':
        applicationData['primaryCategory'],

    'secondaryCategory':
        applicationData['secondaryCategory'],

    'openingTime':
        applicationData['openingTime'],

    'closingTime':
        applicationData['closingTime'],

    'instagramUsername':
        applicationData['instagramUsername'],

    'description':
        applicationData['description'],

    'isActive': true,

    'createdAt':
        FieldValue.serverTimestamp(),
  });
}
  }

  Future<void> rejectVendor({
    required String applicationId,
    required String userId,
  }) async {
    await firestore
        .collection('vendor_applications')
        .doc(applicationId)
        .update({
      'status': 'rejected',
      'reviewedAt':
          FieldValue.serverTimestamp(),
    });

    await firestore
        .collection('users')
        .doc(userId)
        .update({
      'vendorStatus': 'rejected',
    });
  }
}