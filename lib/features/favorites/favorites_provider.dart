import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/favorites_repository.dart';

final favoritesRepositoryProvider =
    Provider<FavoritesRepository>(
  (ref) => FavoritesRepository(),
);