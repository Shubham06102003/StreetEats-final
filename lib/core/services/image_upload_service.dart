import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadService {
  final FirebaseStorage storage =
      FirebaseStorage.instance;

  final ImagePicker picker =
      ImagePicker();

  Future<String?> pickAndUploadImage() async {
    try {
      final XFile? image =
          await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (image == null) {
        return null;
      }

      final file = File(image.path);

      final fileName =
          DateTime.now()
              .millisecondsSinceEpoch
              .toString();

      final ref = storage
          .ref()
          .child('menu_images')
          .child('$fileName.jpg');

      await ref.putFile(file);

      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception(
        'Image upload failed: $e',
      );
    }
  }
}