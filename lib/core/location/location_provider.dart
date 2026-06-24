import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'customer_location_service.dart';

final customerLocationProvider =
    Provider<CustomerLocationService>(
  (ref) =>
      CustomerLocationService(),
);