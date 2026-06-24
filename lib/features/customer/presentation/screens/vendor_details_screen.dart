import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../analytics/analytics_provider.dart';
import '../../../reviews/presentation/widgets/add_review_dialog.dart';
import '../../../reviews/presentation/widgets/review_section.dart';
import '../customer_provider.dart';

class VendorDetailsScreen extends ConsumerStatefulWidget {
  final String vendorId;

  const VendorDetailsScreen({
    super.key,
    required this.vendorId,
  });

  @override
  ConsumerState<VendorDetailsScreen> createState() =>
      _VendorDetailsScreenState();
}

class _VendorDetailsScreenState
    extends ConsumerState<VendorDetailsScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(analyticsRepositoryProvider).trackEvent(
        eventType: 'vendor_view',
        vendorId: widget.vendorId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final repository =
        ref.read(vendorDetailsRepositoryProvider);

    return Scaffold(
      body: FutureBuilder<
          DocumentSnapshot<Map<String, dynamic>>>(
        future: repository.getVendor(
          widget.vendorId,
        ),
        builder: (
          context,
          vendorSnapshot,
        ) {
          if (!vendorSnapshot.hasData) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          final vendor =
              vendorSnapshot.data!.data();

          if (vendor == null) {
            return const Center(
              child:
                  Text('Vendor not found'),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250,
                pinned: true,
                flexibleSpace:
                    FlexibleSpaceBar(
                  background:
                      vendor['coverImageUrl'] !=
                                  null &&
                              vendor['coverImageUrl']
                                  .isNotEmpty
                          ? Image.network(
                              vendor[
                                  'coverImageUrl'],
                              fit:
                                  BoxFit.cover,
                            )
                          : Container(
                              color:
                                  Colors.grey,
                            ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.all(
                    16,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundImage:
                                vendor['logoUrl'] !=
                                            null &&
                                        vendor['logoUrl']
                                            .isNotEmpty
                                    ? NetworkImage(
                                        vendor['logoUrl'],
                                      )
                                    : null,
                          ),

                          const SizedBox(
                            width: 16,
                          ),

                          Expanded(
                            child: Text(
                              vendor['stallName'] ??
                                  '',
                              style:
                                  const TextStyle(
                                fontSize:
                                    24,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      Text(
                        vendor['description'] ??
                            '',
                      ),

                      const SizedBox(
                        height: 24,
                      ),

                      const Text(
                        'Reviews',
                        style:
                            TextStyle(
                          fontSize: 22,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      SizedBox(
                        width:
                            double.infinity,
                        child:
                            ElevatedButton.icon(
                          icon: const Icon(
                            Icons.star,
                          ),
                          label: const Text(
                            'Write Review',
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              context:
                                  context,
                              isScrollControlled:
                                  true,
                              builder: (_) =>
                                  AddReviewDialog(
                                vendorId:
                                    widget.vendorId,
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      ReviewSection(
                        vendorId:
                            widget.vendorId,
                      ),

                      const SizedBox(
                        height: 24,
                      ),

                      const Text(
                        'Menu',
                        style:
                            TextStyle(
                          fontSize: 22,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverFillRemaining(
                child: StreamBuilder<
                    QuerySnapshot<
                        Map<String,
                            dynamic>>>(
                  stream:
                      repository
                          .getVendorMenu(
                    widget.vendorId,
                  ),
                  builder: (
                    context,
                    menuSnapshot,
                  ) {
                    if (!menuSnapshot
                        .hasData) {
                      return const Center(
                        child:
                            CircularProgressIndicator(),
                      );
                    }

                    final menuItems =
                        menuSnapshot
                            .data!
                            .docs;

                    if (menuItems
                        .isEmpty) {
                      return const Center(
                        child: Text(
                          'No menu items available',
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount:
                          menuItems.length,
                      itemBuilder:
                          (
                        context,
                        index,
                      ) {
                        final item =
                            menuItems[index]
                                .data();

                        return Card(
                          margin:
                              const EdgeInsets.symmetric(
                            horizontal:
                                16,
                            vertical:
                                8,
                          ),
                          child:
                              ListTile(
                            leading:
                                item['imageUrl'] !=
                                            null &&
                                        item['imageUrl']
                                            .isNotEmpty
                                    ? Image.network(
                                        item['imageUrl'],
                                        width:
                                            60,
                                        fit:
                                            BoxFit.cover,
                                      )
                                    : null,
                            title: Text(
                              item['name'] ??
                                  '',
                            ),
                            subtitle:
                                Text(
                              item['description'] ??
                                  '',
                            ),
                            trailing:
                                Text(
                              '₹${item['basePrice']}',
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}