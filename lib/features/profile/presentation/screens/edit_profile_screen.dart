import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/image_provider.dart';
import '../../data/profile_repository.dart';
import '../providers/profile_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({
    super.key,
  });

  @override
  ConsumerState<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends ConsumerState<EditProfileScreen> {
  final nameController =
      TextEditingController();

  String photoUrl = '';

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final profile =
        await ref.read(
          userProfileProvider.future,
        );

    if (profile == null) return;

    nameController.text =
        profile['name'] ?? '';

    photoUrl =
        profile['photoUrl'] ?? '';

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> uploadPhoto() async {
    final url =
        await ref
            .read(
              imageUploadServiceProvider,
            )
            .pickAndUploadImage();

    if (url != null) {
      setState(() {
        photoUrl = url;
      });
    }
  }

  Future<void> saveProfile() async {
    try {
      setState(() {
        isLoading = true;
      });

      await ProfileRepository()
          .updateProfile(
        name:
            nameController.text.trim(),
        photoUrl: photoUrl,
      );

      ref.invalidate(
        userProfileProvider,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            '✅ Profile Updated',
          ),
        ),
      );

      Navigator.pop(context);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
        ),
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: uploadPhoto,
              child: CircleAvatar(
                radius: 60,
                backgroundImage:
                    photoUrl.isNotEmpty
                    ? NetworkImage(
                        photoUrl,
                      )
                    : null,
                child:
                    photoUrl.isEmpty
                    ? const Icon(
                        Icons.camera_alt,
                        size: 40,
                      )
                    : null,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            TextField(
              controller:
                  nameController,
              decoration:
                  const InputDecoration(
                labelText:
                    'Full Name',
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            SizedBox(
              width:
                  double.infinity,
              child: ElevatedButton(
                onPressed:
                    isLoading
                    ? null
                    : saveProfile,
                child: Text(
                  isLoading
                      ? 'Saving...'
                      : 'Save Profile',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}