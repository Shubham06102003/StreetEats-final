import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../favorites_provider.dart';

class FavoriteButton
    extends ConsumerWidget {
  final String vendorId;

  const FavoriteButton({
    super.key,
    required this.vendorId,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final repository =
        ref.read(
          favoritesRepositoryProvider,
        );

    return StreamBuilder<bool>(
      stream:
          repository.isFavorite(
        vendorId,
      ),
      builder:
          (context, snapshot) {
        final isFavorite =
            snapshot.data ??
            false;

        return CircleAvatar(
          backgroundColor:
              Colors.white,
          child: IconButton(
            icon: Icon(
              isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border,
              color:
                  Colors.red,
            ),
            onPressed: () {
              repository
                  .toggleFavorite(
                vendorId,
              );
            },
          ),
        );
      },
    );
  }
}