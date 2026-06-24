import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/vendor_preview_card.dart';
import '../../../../core/providers/image_provider.dart';
import '../vendor_provider.dart';

class StallProfileScreen extends ConsumerStatefulWidget {
  const StallProfileScreen({super.key});

  @override
  ConsumerState<StallProfileScreen> createState() => _StallProfileScreenState();
}

class _StallProfileScreenState extends ConsumerState<StallProfileScreen> {
  final stallNameController = TextEditingController();

  final descriptionController = TextEditingController();

  final whatsappController = TextEditingController();

  final instagramController = TextEditingController();

  final openingController = TextEditingController();

  final closingController = TextEditingController();

  String logoUrl = '';
  String coverImageUrl = '';
  String primaryCategory = '';
  String secondaryCategory = '';

  bool isLoading = false;

  @override
  void initState() {
    stallNameController.addListener(() => setState(() {}));

    descriptionController.addListener(() => setState(() {}));

    instagramController.addListener(() => setState(() {}));

    openingController.addListener(() => setState(() {}));

    closingController.addListener(() => setState(() {}));
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final data = await ref.read(vendorRepositoryProvider).getVendorProfile();

    if (data == null) return;

    stallNameController.text = data['stallName'] ?? '';

    descriptionController.text = data['description'] ?? '';

    whatsappController.text = data['whatsapp'] ?? '';

    instagramController.text = data['instagram'] ?? '';

    openingController.text = data['openingTime'] ?? '';

    closingController.text = data['closingTime'] ?? '';

    logoUrl = data['logoUrl'] ?? '';

    coverImageUrl = data['coverImageUrl'] ?? '';

    primaryCategory = data['primaryCategory'] ?? '';

    secondaryCategory = data['secondaryCategory'] ?? '';

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> saveProfile() async {
    try {
      setState(() {
        isLoading = true;
      });

      await ref
          .read(vendorRepositoryProvider)
          .saveStallProfile(
            stallName: stallNameController.text.trim(),
            description: descriptionController.text.trim(),
            whatsapp: whatsappController.text.trim(),
            instagram: instagramController.text.trim(),
            openingTime: openingController.text.trim(),
            closingTime: closingController.text.trim(),
            logoUrl: logoUrl,
            coverImageUrl: coverImageUrl,
          );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('✅ Stall profile saved')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> uploadLogo() async {
    final url = await ref.read(imageUploadServiceProvider).pickAndUploadImage();

    if (url != null) {
      setState(() {
        logoUrl = url;
      });
    }
  }

  Future<void> uploadCover() async {
    final url = await ref.read(imageUploadServiceProvider).pickAndUploadImage();

    if (url != null) {
      setState(() {
        coverImageUrl = url;
      });
    }
  }

  @override
  void dispose() {
    stallNameController.dispose();
    descriptionController.dispose();
    whatsappController.dispose();
    instagramController.dispose();
    openingController.dispose();
    closingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Stall')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            VendorPreviewCard(
              stallName: stallNameController.text,
              description: descriptionController.text,
              logoUrl: logoUrl,
              coverImageUrl: coverImageUrl,
              openingTime: openingController.text,
              closingTime: closingController.text,
              instagram: instagramController.text,
              primaryCategory: primaryCategory,
              secondaryCategory: secondaryCategory,
            ),

            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Cover Image',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),

            const SizedBox(height: 8),
            GestureDetector(
              onTap: uploadCover,
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: coverImageUrl.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image, size: 50),
                            SizedBox(height: 8),
                            Text('Upload Cover Image'),
                          ],
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(coverImageUrl, fit: BoxFit.cover),
                      ),
              ),
            ),

            const SizedBox(height: 12),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Logo',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),

            const SizedBox(height: 8),
            GestureDetector(
              onTap: uploadLogo,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: logoUrl.isNotEmpty
                    ? NetworkImage(logoUrl)
                    : null,
                child: logoUrl.isEmpty
                    ? const Icon(Icons.camera_alt, size: 35)
                    : null,
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: stallNameController,
              decoration: const InputDecoration(labelText: 'Stall Name'),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Description'),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: whatsappController,
              decoration: const InputDecoration(labelText: 'WhatsApp'),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: instagramController,
              decoration: const InputDecoration(labelText: 'Instagram'),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: openingController,
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Opening Time'),
              onTap: () async {
                final localizations = MaterialLocalizations.of(context);

                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if (time == null) return;

                openingController.text = localizations.formatTimeOfDay(time);
              },
            ),

            const SizedBox(height: 16),

            TextField(
              controller: closingController,
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Closing Time'),
              onTap: () async {
                final localizations = MaterialLocalizations.of(context);

                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if (time == null) return;

                closingController.text = localizations.formatTimeOfDay(time);
              },
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : saveProfile,
                child: const Text('Save Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
