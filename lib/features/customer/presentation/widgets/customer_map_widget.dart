import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:go_router/go_router.dart';

class CustomerMapWidget extends StatelessWidget {
  final double userLatitude;
  final double userLongitude;

  final List<Map<String, dynamic>> vendors;

  const CustomerMapWidget({
    super.key,
    required this.userLatitude,
    required this.userLongitude,
    required this.vendors,
  });

  @override
  Widget build(BuildContext context) {
    final markers = <Marker>[
      Marker(
        point: LatLng(userLatitude, userLongitude),
        width: 60,
        height: 60,
        child: const Icon(Icons.my_location, size: 35, color: Colors.blue),
      ),
    ];

    for (final vendor in vendors) {
      final vendorId = vendor['id'];
      final lat = vendor['latitude'];
      final lng = vendor['longitude'];

      if (lat == null || lng == null) continue;

      markers.add(
        Marker(
          point: LatLng(lat.toDouble(), lng.toDouble()),
          width: 60,
          height: 60,
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (_) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vendor['stallName'] ?? '',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(vendor['primaryCategory'] ?? ''),

                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);

                              context.push('/vendor-details', extra: vendorId);
                            },
                            child: const Text('View Stall'),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: const Icon(
              Icons.restaurant,
              color: Colors.deepOrange,
              size: 40,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 250,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(userLatitude, userLongitude),
            initialZoom: 15,
          ),
          children: [
            TileLayer(
              urlTemplate:
                  'https://a.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.streetfoodfinder.app',
            ),

            MarkerLayer(markers: markers),
          ],
        ),
      ),
    );
  }
}
