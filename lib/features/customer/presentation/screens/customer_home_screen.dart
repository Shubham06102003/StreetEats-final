import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../vendor/presentation/widgets/vendor_preview_card.dart';
import '../customer_provider.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/location/location_provider.dart';
import '../widgets/customer_map_widget.dart';

class CustomerHomeScreen extends ConsumerStatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  ConsumerState<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends ConsumerState<CustomerHomeScreen> {
  final searchController = TextEditingController();

  String selectedCategory = 'All';

  List<String> categories = ['All'];
  double? userLatitude;
  double? userLongitude;

  @override
  void initState() {
    super.initState();
    loadCategories();
    loadUserLocation();
  }

  Future<void> loadUserLocation() async {
    try {
      final position = await ref
          .read(customerLocationProvider)
          .getCurrentLocation();

      if (!mounted) return;

      setState(() {
        userLatitude = position.latitude;

        userLongitude = position.longitude;
      });
    } catch (_) {}
  }

  double calculateDistance(double vendorLat, double vendorLng) {
    if (userLatitude == null || userLongitude == null) {
      return 0;
    }

    return Geolocator.distanceBetween(
          userLatitude!,
          userLongitude!,
          vendorLat,
          vendorLng,
        ) /
        1000;
  }

  Future<void> loadCategories() async {
    final data = await ref.read(customerRepositoryProvider).getCategories();

    if (!mounted) return;

    setState(() {
      categories = data;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repository = ref.read(customerRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Street Food Finder')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Search stall...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (_) {
                setState(() {});
              },
            ),
          ),

          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];

                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: selectedCategory == category,
                    onSelected: (_) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: repository.getApprovedVendors(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No vendors available'));
                }

                final vendors = snapshot.data!.docs;

                final filteredVendors = vendors.where((doc) {
                  final data = doc.data();

                  final stallName = (data['stallName'] ?? '')
                      .toString()
                      .toLowerCase();

                  final category = (data['primaryCategory'] ?? '').toString();

                  final query = searchController.text.toLowerCase();

                  final matchesSearch = stallName.contains(query);

                  final matchesCategory =
                      selectedCategory == 'All' || category == selectedCategory;

                  return matchesSearch && matchesCategory;
                }).toList();

                filteredVendors.sort((a, b) {
                  final aData = a.data();
                  final bData = b.data();

                  final aDistance = calculateDistance(
                    (aData['latitude'] ?? 0).toDouble(),
                    (aData['longitude'] ?? 0).toDouble(),
                  );

                  final bDistance = calculateDistance(
                    (bData['latitude'] ?? 0).toDouble(),
                    (bData['longitude'] ?? 0).toDouble(),
                  );

                  return aDistance.compareTo(bDistance);
                });

                if (filteredVendors.isEmpty) {
                  return const Center(child: Text('No matching vendors found'));
                }

                return Column(
                  children: [
                    if (userLatitude != null && userLongitude != null)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: CustomerMapWidget(
                          userLatitude: userLatitude!,
                          userLongitude: userLongitude!,
                          vendors: filteredVendors
                              .map((e) => {'id': e.id, ...e.data()})
                              .toList(),
                        ),
                      ),

                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredVendors.length,
                        itemBuilder: (context, index) {
                          final data = filteredVendors[index].data();

                          final distance = calculateDistance(
                            (data['latitude'] ?? 0).toDouble(),
                            (data['longitude'] ?? 0).toDouble(),
                          );

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 4,
                                    bottom: 4,
                                  ),
                                  child: Text(
                                    '📍 ${distance.toStringAsFixed(1)} km away',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),

                                GestureDetector(
                                  onTap: () {
                                    context.push(
                                      '/vendor-details',
                                      extra: filteredVendors[index].id,
                                    );
                                  },
                                  child: VendorPreviewCard(
                                    stallName: data['stallName'] ?? '',
                                    description: data['description'] ?? '',
                                    logoUrl: data['logoUrl'] ?? '',
                                    coverImageUrl: data['coverImageUrl'] ?? '',
                                    openingTime: data['openingTime'] ?? '',
                                    closingTime: data['closingTime'] ?? '',
                                    instagram: data['instagram'] ?? '',
                                    primaryCategory:
                                        data['primaryCategory'] ?? '',
                                    secondaryCategory:
                                        data['secondaryCategory'] ?? '',
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
