import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../menu_provider.dart';

class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.read(menuRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Menu')),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/add-menu-item');
        },
        child: const Icon(Icons.add),
      ),

      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: repository.getVendorMenuItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No menu items added yet'));
          }

          final items = snapshot.data!.docs;

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final doc = items[index];
              final data = doc.data();

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(data['name'] ?? ''),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('₹${data['basePrice']}'),

                      Text(data['menuCategory'] ?? ''),

                      Text(
                        (data['isAvailable'] ?? true)
                            ? '✅ Available'
                            : '❌ Sold Out',
                      ),
                    ],
                  ),

                  trailing: SizedBox(
                    width: 130,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Switch(
                          value: data['isAvailable'] ?? true,
                          onChanged: (value) async {
                            await repository.updateAvailability(
                              menuItemId: doc.id,
                              isAvailable: value,
                            );
                          },
                        ),

                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            context.push(
                              '/edit-menu-item',
                              extra: {
                                'id': doc.id,
                                'name': data['name'],
                                'price': data['basePrice'],
                                'category': data['menuCategory'],
                                'description': data['description'],
                              },
                            );
                          },
                        ),

                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            final shouldDelete = await showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Delete Item'),
                                  content: Text(
                                    'Are you sure you want to delete "${data['name']}"?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, false);
                                      },
                                      child: const Text('Cancel'),
                                    ),

                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (shouldDelete == true) {
                              await repository.deleteMenuItem(doc.id);

                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('🗑️ Menu item deleted'),
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
