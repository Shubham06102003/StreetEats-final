import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/profile_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text(
            'Error: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('No Profile Found'));
          }

          final email = profile['email'] ?? '';
          final role = profile['role'] ?? 'customer';
          final vendorStatus = profile['vendorStatus'] ?? 'none';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(blurRadius: 10, color: Colors.black12),
                    ],
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: (profile['photoUrl'] ?? '').isNotEmpty
                            ? NetworkImage(profile['photoUrl'])
                            : null,
                        child: (profile['photoUrl'] ?? '').isEmpty
                            ? const Icon(Icons.person, size: 40)
                            : null,
                      ),

                      const SizedBox(height: 16),

                      Text(
                        (profile['name'] ?? '').isEmpty
                            ? 'Street Food User'
                            : profile['name'],
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(email, style: const TextStyle(color: Colors.grey)),

                      const SizedBox(height: 16),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          role.toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Vendor Status: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(vendorStatus),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                if (vendorStatus == 'none')
                  ListTile(
                    leading: const Icon(Icons.storefront),
                    title: const Text('Become Vendor'),
                    subtitle: const Text('Apply for vendor account'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      context.push('/vendor-application');
                    },
                  ),

                if (vendorStatus == 'pending')
                  const ListTile(
                    leading: Icon(Icons.hourglass_top, color: Colors.orange),
                    title: Text('Application Pending'),
                    subtitle: Text('Waiting for admin approval'),
                  ),

                if (vendorStatus == 'approved')
                  ListTile(
                    leading: const Icon(Icons.store, color: Colors.green),
                    title: const Text('Vendor Dashboard'),
                    subtitle: const Text('Manage your stall'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      context.push('/vendor-dashboard');
                    },
                  ),

                if (vendorStatus == 'rejected')
                  ListTile(
                    leading: const Icon(Icons.refresh, color: Colors.red),
                    title: const Text('Apply Again'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      context.push('/vendor-application');
                    },
                  ),

                const Divider(),

                ListTile(
                  leading: const Icon(Icons.favorite),
                  title: const Text('Favorites'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {},
                ),

                const Divider(),

                ListTile(
                  leading: const Icon(Icons.reviews),
                  title: const Text('My Reviews'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.admin_panel_settings),
                  title: const Text('Admin Dashboard'),
                  onTap: () {
                    context.push('/admin');
                  },
                ),

                const Divider(),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();

                      if (context.mounted) {
                        context.go('/');
                      }
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
