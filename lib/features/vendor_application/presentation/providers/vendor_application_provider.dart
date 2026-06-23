import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/vendor_application_repository.dart';

final vendorApplicationProvider =
    Provider<VendorApplicationRepository>((ref) {
  return VendorApplicationRepository();
});