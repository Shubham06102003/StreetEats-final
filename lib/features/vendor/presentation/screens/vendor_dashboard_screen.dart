import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../vendor_provider.dart';

class VendorDashboardScreen extends ConsumerWidget {
  const VendorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vendor Dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.storefront),
              title: const Text('My Stall'),
              subtitle: const Text('Manage business details'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.restaurant_menu),
              title: const Text('My Menu'),
              subtitle: const Text('Manage food items'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                context.push('/menu');
              },
            ),
          ),

          Card(
            child: FutureBuilder<bool>(
              future: ref.read(vendorRepositoryProvider).isLocationConfigured(),
              builder: (context, snapshot) {
                final configured = snapshot.data ?? false;

                return ListTile(
                  leading: Icon(
                    Icons.location_on,
                    color: configured ? Colors.green : Colors.orange,
                  ),
                  title: const Text('Location'),
                  subtitle: Text(
                    configured ? 'Configured ✅' : 'Not Configured ❌',
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    context.push('/vendor-location');
                  },
                );
              },
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.analytics),
              title: const Text('Analytics'),
              subtitle: const Text('View performance'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
