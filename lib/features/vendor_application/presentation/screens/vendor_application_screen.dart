import 'package:flutter/material.dart';

class VendorApplicationScreen extends StatefulWidget {
  const VendorApplicationScreen({super.key});

  @override
  State<VendorApplicationScreen> createState() =>
      _VendorApplicationScreenState();
}

class _VendorApplicationScreenState extends State<VendorApplicationScreen> {
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
                onPressed: () {},
                child: const Text('Submit Application'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
