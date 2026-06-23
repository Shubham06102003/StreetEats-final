import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/vendor_repository.dart';

final vendorRepositoryProvider =
    Provider<VendorRepository>((ref) {
  return VendorRepository();
});