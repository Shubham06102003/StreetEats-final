import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/vendor_details_repository.dart';

import '../data/customer_repository.dart';

final customerRepositoryProvider = Provider<CustomerRepository>(
  (ref) => CustomerRepository(),
);

final vendorDetailsRepositoryProvider = Provider<VendorDetailsRepository>(
  (ref) => VendorDetailsRepository(),
);
