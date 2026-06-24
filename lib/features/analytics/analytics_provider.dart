import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/analytics_repository.dart';

final analyticsRepositoryProvider =
    Provider<AnalyticsRepository>(
  (ref) => AnalyticsRepository(),
);