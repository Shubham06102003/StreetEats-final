import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/image_upload_service.dart';
import '../data/menu_repository.dart';

final menuRepositoryProvider =
    Provider<MenuRepository>((ref) {
  return MenuRepository();
});

final imageUploadServiceProvider =
    Provider<ImageUploadService>(
  (ref) => ImageUploadService(),
);