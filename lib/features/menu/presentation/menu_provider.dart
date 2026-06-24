import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/menu_repository.dart';

final menuRepositoryProvider =
    Provider<MenuRepository>((ref) {
  return MenuRepository();
});
