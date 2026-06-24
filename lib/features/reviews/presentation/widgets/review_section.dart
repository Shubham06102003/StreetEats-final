import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../review_provider.dart';

class ReviewSection extends ConsumerWidget {
  final String vendorId;

  const ReviewSection({super.key, required this.vendorId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.read(reviewRepositoryProvider);

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: repository.getReviews(vendorId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container(
            padding: const EdgeInsets.all(12),
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final reviews = snapshot.data?.docs ?? [];

        double avgRating = 0;

        if (reviews.isNotEmpty) {
          avgRating =
              reviews.fold<double>(0, (total, doc) {
                final rating = (doc.data()['rating'] ?? 0).toDouble();

                return total + rating;
              }) /
              reviews.length;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber),

                const SizedBox(width: 6),

                Text(
                  avgRating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(width: 8),

                Text('(${reviews.length} reviews)'),
              ],
            ),

            const SizedBox(height: 16),

            if (reviews.isEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('No reviews yet'),
              ),

            ...reviews.map((reviewDoc) {
              final review = reviewDoc.data();

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: (review['userPhotoUrl'] ?? '').isNotEmpty
                        ? NetworkImage(review['userPhotoUrl'])
                        : null,
                    child: (review['userPhotoUrl'] ?? '').isEmpty
                        ? const Icon(Icons.person)
                        : null,
                  ),

                  title: Text(review['userName'] ?? 'Customer'),

                  subtitle: Text(review['review'] ?? ''),

                  trailing: Text('⭐ ${review['rating']}'),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
