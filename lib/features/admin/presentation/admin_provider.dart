import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/admin_repository.dart';
final adminRepositoryProvider =
    Provider<AdminRepository>((ref) {
  return AdminRepository();
});