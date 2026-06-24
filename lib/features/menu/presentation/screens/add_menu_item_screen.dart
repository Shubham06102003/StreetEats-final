import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../menu_provider.dart';

class AddMenuItemScreen extends ConsumerStatefulWidget {
  final String? menuItemId;
  final String? initialName;
  final int? initialPrice;
  final String? initialCategory;
  final String? initialDescription;

  const AddMenuItemScreen({
    super.key,
    this.menuItemId,
    this.initialName,
    this.initialPrice,
    this.initialCategory,
    this.initialDescription,
  });

  @override
  ConsumerState<AddMenuItemScreen> createState() => _AddMenuItemScreenState();
}

class _AddMenuItemScreenState extends ConsumerState<AddMenuItemScreen> {
  bool get isEditMode => widget.menuItemId != null;
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final customCategoryController = TextEditingController();

  bool isLoading = false;

  String selectedCategory = 'Food';

  final menuCategories = [
    'Food',
    'Beverages',
    'Combos',
    'Desserts',
    'Specials',
    'Other',
  ];

  @override
  void initState() {
    super.initState();

    if (isEditMode) {
      nameController.text = widget.initialName ?? '';

      priceController.text = widget.initialPrice?.toString() ?? '';

      descriptionController.text = widget.initialDescription ?? '';

      selectedCategory = widget.initialCategory ?? 'Food';
    }
  }

  Future<void> saveMenuItem() async {
    try {
      if (nameController.text.trim().isEmpty) {
        throw Exception('Please enter food name');
      }

      if (priceController.text.trim().isEmpty) {
        throw Exception('Please enter price');
      }

      setState(() {
        isLoading = true;
      });

      String category = selectedCategory;

      if (selectedCategory == 'Other') {
        category = customCategoryController.text.trim();
      }

      if (isEditMode) {
        await ref
            .read(menuRepositoryProvider)
            .updateMenuItem(
              menuItemId: widget.menuItemId!,
              name: nameController.text.trim(),
              menuCategory: category,
              description: descriptionController.text.trim(),
              basePrice: int.parse(priceController.text.trim()),
            );
      } else {
        await ref
            .read(menuRepositoryProvider)
            .addMenuItem(
              name: nameController.text.trim(),
              menuCategory: category,
              description: descriptionController.text.trim(),
              basePrice: int.parse(priceController.text.trim()),
              imageUrl: '',
            );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditMode ? '✅ Menu item updated' : '✅ Menu item added',
          ),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    customCategoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Menu Item' : 'Add Menu Item'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Food Name',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Price (₹)',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              initialValue: selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Menu Category',
                border: OutlineInputBorder(),
              ),
              items: menuCategories
                  .map(
                    (category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
            ),

            if (selectedCategory == 'Other') ...[
              const SizedBox(height: 16),

              TextField(
                controller: customCategoryController,
                decoration: const InputDecoration(
                  labelText: 'Custom Category',
                  border: OutlineInputBorder(),
                ),
              ),
            ],

            const SizedBox(height: 16),

            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : saveMenuItem,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : Text(isEditMode ? 'Update Item' : 'Save Item'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
