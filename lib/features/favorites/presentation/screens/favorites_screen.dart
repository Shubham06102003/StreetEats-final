import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../customer/data/vendor_details_repository.dart';
import '../../../vendor/presentation/widgets/vendor_preview_card.dart';
import '../../favorites_provider.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final favoritesRepo =
        ref.read(
          favoritesRepositoryProvider,
        );

    final vendorRepo =
        VendorDetailsRepository();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Favorites',
        ),
      ),
      body: StreamBuilder<
          QuerySnapshot<
              Map<String, dynamic>>>(
        stream:
            favoritesRepo
                .getFavorites(),
        builder:
            (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          final favorites =
              snapshot.data!.docs;

          if (favorites.isEmpty) {
            return const Center(
              child: Text(
                'No favorite stalls yet ❤️',
              ),
            );
          }

          return ListView.builder(
            padding:
                const EdgeInsets.all(
              16,
            ),
            itemCount:
                favorites.length,
            itemBuilder:
                (context, index) {
              final vendorId =
                  favorites[index]
                      .id;

              return FutureBuilder<
                  DocumentSnapshot<
                      Map<String,
                          dynamic>>>(
                future:
                    vendorRepo
                        .getVendor(
                  vendorId,
                ),
                builder:
                    (
                      context,
                      vendorSnapshot,
                    ) {
                  if (!vendorSnapshot
                      .hasData) {
                    return const SizedBox();
                  }

                  final vendor =
                      vendorSnapshot
                          .data!
                          .data();

                  if (vendor ==
                      null) {
                    return const SizedBox();
                  }

                  return Padding(
                    padding:
                        const EdgeInsets.only(
                      bottom:
                          16,
                    ),
                    child:
                        GestureDetector(
                      onTap: () {
                        context.push(
                          '/vendor-details',
                          extra:
                              vendorId,
                        );
                      },
                      child:
                          VendorPreviewCard(
                        stallName:
                            vendor['stallName'] ??
                                '',
                        description:
                            vendor['description'] ??
                                '',
                        logoUrl:
                            vendor['logoUrl'] ??
                                '',
                        coverImageUrl:
                            vendor['coverImageUrl'] ??
                                '',
                        openingTime:
                            vendor['openingTime'] ??
                                '',
                        closingTime:
                            vendor['closingTime'] ??
                                '',
                        instagram:
                            vendor['instagram'] ??
                                '',
                        primaryCategory:
                            vendor['primaryCategory'] ??
                                '',
                        secondaryCategory:
                            vendor['secondaryCategory'] ??
                                '',
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}