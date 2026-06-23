import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/vendor_application_provider.dart';

class VendorApplicationScreen extends ConsumerStatefulWidget {
  const VendorApplicationScreen({super.key});

  @override
  ConsumerState<VendorApplicationScreen> createState() =>
      _VendorApplicationScreenState();
}

class _VendorApplicationScreenState
    extends ConsumerState<VendorApplicationScreen> {
  final ownerNameController = TextEditingController();
  final phoneController = TextEditingController();
  final whatsappController = TextEditingController();

  final businessNameController = TextEditingController();

  final cityController = TextEditingController();
  final areaController = TextEditingController();

  final instagramController = TextEditingController();
  final descriptionController = TextEditingController();

  final openingTimeController = TextEditingController();
  final closingTimeController = TextEditingController();

  final customPrimaryCategoryController = TextEditingController();

  final customSecondaryCategoryController = TextEditingController();

  String selectedState = 'Maharashtra';

  String selectedPrimaryCategory = 'Momos';
  String selectedSecondaryCategory = 'None';

  final states = [
    'Maharashtra',
    'Gujarat',
    'Karnataka',
    'Telangana',
    'Madhya Pradesh',
    'Goa',
    'Other',
  ];

  final categories = [
    'Momos',
    'Chinese',
    'Fast Food',
    'South Indian',
    'Maharashtrian',
    'Tea/Coffee',
    'Juices',
    'Snacks',
    'Other',
  ];

  final secondaryCategories = [
    'None',
    'Momos',
    'Chinese',
    'Fast Food',
    'South Indian',
    'Maharashtrian',
    'Tea/Coffee',
    'Juices',
    'Snacks',
    'Other',
  ];

  Future<void> selectTime(TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (!mounted || picked == null) return;

    controller.text = picked.format(context);
  }

  @override
  void dispose() {
    ownerNameController.dispose();
    phoneController.dispose();
    whatsappController.dispose();

    businessNameController.dispose();

    cityController.dispose();
    areaController.dispose();

    instagramController.dispose();
    descriptionController.dispose();

    openingTimeController.dispose();
    closingTimeController.dispose();

    customPrimaryCategoryController.dispose();
    customSecondaryCategoryController.dispose();

    super.dispose();
  }

  Future<void> submitApplication() async {
    try {
      final primaryCategory = selectedPrimaryCategory == 'Other'
          ? customPrimaryCategoryController.text.trim()
          : selectedPrimaryCategory;

      final secondaryCategory = selectedSecondaryCategory == 'Other'
          ? customSecondaryCategoryController.text.trim()
          : selectedSecondaryCategory;

      await ref
          .read(vendorApplicationProvider)
          .submitApplication(
            ownerName: ownerNameController.text.trim(),
            phoneNumber: phoneController.text.trim(),
            whatsappNumber: whatsappController.text.trim(),
            businessName: businessNameController.text.trim(),
            state: selectedState,
            city: cityController.text.trim(),
            operatingArea: areaController.text.trim(),
            primaryCategory: primaryCategory,
            secondaryCategory: secondaryCategory,
            openingTime: openingTimeController.text.trim(),
            closingTime: closingTimeController.text.trim(),
            instagramUsername: instagramController.text.trim(),
            description: descriptionController.text.trim(),
          );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vendor application submitted successfully'),
        ),
      );

      context.pop();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Become Vendor')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: ownerNameController,
              decoration: const InputDecoration(labelText: 'Owner Name'),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: whatsappController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'WhatsApp Number'),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: businessNameController,
              decoration: const InputDecoration(labelText: 'Business Name'),
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              initialValue: selectedState,
              decoration: const InputDecoration(labelText: 'State'),
              items: states
                  .map(
                    (state) =>
                        DropdownMenuItem(value: state, child: Text(state)),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedState = value!;
                });
              },
            ),

            const SizedBox(height: 16),

            TextField(
              controller: cityController,
              decoration: const InputDecoration(labelText: 'City'),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: areaController,
              decoration: const InputDecoration(labelText: 'Operating Area'),
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              initialValue: selectedPrimaryCategory,
              decoration: const InputDecoration(labelText: 'Primary Category'),
              items: categories
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedPrimaryCategory = value!;
                });
              },
            ),

            if (selectedPrimaryCategory == 'Other') ...[
              const SizedBox(height: 16),

              TextField(
                controller: customPrimaryCategoryController,
                decoration: const InputDecoration(
                  labelText: 'Enter Primary Category',
                ),
              ),
            ],

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              initialValue: selectedSecondaryCategory,
              decoration: const InputDecoration(
                labelText: 'Secondary Category (Optional)',
              ),
              items: secondaryCategories
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedSecondaryCategory = value!;
                });
              },
            ),

            if (selectedSecondaryCategory == 'Other') ...[
              const SizedBox(height: 16),

              TextField(
                controller: customSecondaryCategoryController,
                decoration: const InputDecoration(
                  labelText: 'Enter Secondary Category',
                ),
              ),
            ],

            const SizedBox(height: 16),

            TextField(
              controller: openingTimeController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Opening Time',
                suffixIcon: Icon(Icons.access_time),
              ),
              onTap: () {
                selectTime(openingTimeController);
              },
            ),

            const SizedBox(height: 16),

            TextField(
              controller: closingTimeController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Closing Time',
                suffixIcon: Icon(Icons.access_time),
              ),
              onTap: () {
                selectTime(closingTimeController);
              },
            ),

            const SizedBox(height: 16),

            TextField(
              controller: instagramController,
              decoration: const InputDecoration(
                labelText: 'Instagram Username',
                hintText: 'food_vendor_pune',
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Description'),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: submitApplication,
                child: const Text('Submit Application'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
