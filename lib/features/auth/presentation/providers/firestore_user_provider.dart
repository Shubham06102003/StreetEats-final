import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/firestore_user_datasource.dart';

final firestoreUserProvider =
    Provider<FirestoreUserDataSource>((ref) {
  return FirestoreUserDataSource();
});