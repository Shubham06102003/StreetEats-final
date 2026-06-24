import 'package:flutter/material.dart';

class VendorPreviewCard extends StatelessWidget {
  final String stallName;
  final String description;
  final String logoUrl;
  final String coverImageUrl;
  final String openingTime;
  final String closingTime;
  final String instagram;
  final String primaryCategory;
  final String secondaryCategory;

  const VendorPreviewCard({
    super.key,
    required this.stallName,
    required this.description,
    required this.logoUrl,
    required this.coverImageUrl,
    required this.openingTime,
    required this.closingTime,
    required this.instagram,
    required this.primaryCategory,
    required this.secondaryCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 180,
            width: double.infinity,
            child: coverImageUrl.isNotEmpty
                ? Image.network(coverImageUrl, fit: BoxFit.cover)
                : Container(
                    color: Colors.grey.shade300,
                    child: const Center(child: Icon(Icons.image, size: 60)),
                  ),
          ),

          Transform.translate(
            offset: const Offset(16, -30),
            child: CircleAvatar(
              radius: 35,
              backgroundColor: Colors.white,
              backgroundImage: logoUrl.isNotEmpty
                  ? NetworkImage(logoUrl)
                  : null,
              child: logoUrl.isEmpty
                  ? const Icon(Icons.storefront, size: 35)
                  : null,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stallName.isEmpty ? 'Your Stall Name' : stallName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                if (primaryCategory.isNotEmpty)
                  Text(
                    secondaryCategory.isNotEmpty && secondaryCategory != 'None'
                        ? '$primaryCategory • $secondaryCategory'
                        : primaryCategory,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: openingTime.isNotEmpty && closingTime.isNotEmpty
                        ? Colors.green
                        : Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    openingTime.isNotEmpty && closingTime.isNotEmpty
                        ? 'Open Now'
                        : 'Closed',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                const SizedBox(height: 8),

                Text(
                  description.isEmpty
                      ? 'Your stall description will appear here'
                      : description,
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    const Icon(Icons.access_time, size: 18),

                    const SizedBox(width: 6),

                    Text(
                      openingTime.isNotEmpty && closingTime.isNotEmpty
                          ? '$openingTime - $closingTime'
                          : 'Business hours not set',
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    const Icon(Icons.star, size: 18, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      'New Vendor',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),

                if (instagram.isNotEmpty)
                  Row(
                    children: [
                      const Icon(Icons.camera_alt, size: 18),

                      const SizedBox(width: 6),

                      Text(instagram),
                    ],
                  ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
