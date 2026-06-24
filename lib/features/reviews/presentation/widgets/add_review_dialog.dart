import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../review_provider.dart';

class AddReviewDialog extends ConsumerStatefulWidget {
  final String vendorId;

  const AddReviewDialog({
    super.key,
    required this.vendorId,
  });

  @override
  ConsumerState<AddReviewDialog>
      createState() =>
          _AddReviewDialogState();
}

class _AddReviewDialogState
    extends ConsumerState<AddReviewDialog> {
  double rating = 5;

  final reviewController =
      TextEditingController();

  bool isLoading = false;

  Future<void> submitReview() async {
    try {
      setState(() {
        isLoading = true;
      });

      await ref
          .read(
            reviewRepositoryProvider,
          )
          .addReview(
            vendorId:
                widget.vendorId,
            rating: rating,
            review:
                reviewController.text
                    .trim(),
          );

      if (!mounted) return;

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Padding(
      padding:
          const EdgeInsets.all(20),
      child: Column(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          const Text(
            'Write Review',
            style: TextStyle(
              fontSize: 20,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          DropdownButton<double>(
            value: rating,
            items: [
              1,
              2,
              3,
              4,
              5,
            ]
                .map(
                  (e) =>
                      DropdownMenuItem(
                    value:
                        e.toDouble(),
                    child: Text(
                      '⭐ $e',
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                rating = value!;
              });
            },
          ),

          const SizedBox(
            height: 16,
          ),

          TextField(
            controller:
                reviewController,
            maxLines: 4,
            decoration:
                const InputDecoration(
              hintText:
                  'Write your review',
              border:
                  OutlineInputBorder(),
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          SizedBox(
            width:
                double.infinity,
            child: ElevatedButton(
              onPressed:
                  isLoading
                      ? null
                      : submitReview,
              child: const Text(
                'Submit Review',
              ),
            ),
          ),
        ],
      ),
    );
  }
}