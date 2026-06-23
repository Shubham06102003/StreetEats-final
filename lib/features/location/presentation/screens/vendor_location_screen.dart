import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../../../vendor/presentation/vendor_provider.dart';
import '../location_provider.dart';

class VendorLocationScreen extends ConsumerStatefulWidget {
  const VendorLocationScreen({super.key});

  @override
  ConsumerState<VendorLocationScreen> createState() =>
      _VendorLocationScreenState();
}

class _VendorLocationScreenState extends ConsumerState<VendorLocationScreen> {
  final addressController = TextEditingController();
  final landmarkController = TextEditingController();

  double? latitude;
  double? longitude;

  bool isLoading = false;
  bool hasLoadedData = false;

  Future<void> loadExistingLocation() async {
    try {
      final vendor = await ref
          .read(vendorRepositoryProvider)
          .getVendorProfile();

      if (vendor == null) return;

      latitude = (vendor['latitude'] as num?)?.toDouble();
      longitude = (vendor['longitude'] as num?)?.toDouble();

      addressController.text = vendor['address'] ?? '';

      landmarkController.text = vendor['landmark'] ?? '';

      if (!mounted) return;

      setState(() {
        hasLoadedData = true;
      });
    } catch (e) {
      debugPrint('Error loading vendor location: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    loadExistingLocation();
  }

  Future<void> getCurrentLocation() async {
    try {
      setState(() {
        isLoading = true;
      });

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions permanently denied');
      }

      final position = await Geolocator.getCurrentPosition();

      latitude = position.latitude;
      longitude = position.longitude;

      final placemarks = await placemarkFromCoordinates(latitude!, longitude!);

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        addressController.text =
            '${place.street ?? ''}, '
            '${place.subLocality ?? ''}, '
            '${place.locality ?? ''}, '
            '${place.administrativeArea ?? ''}';
      }

      setState(() {});
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> saveLocation() async {
    try {
      if (latitude == null || longitude == null) {
        throw Exception('Please fetch location first');
      }

      setState(() {
        isLoading = true;
      });

      await ref
          .read(locationRepositoryProvider)
          .saveVendorLocation(
            latitude: latitude!,
            longitude: longitude!,
            address: addressController.text.trim(),
            landmark: landmarkController.text.trim(),
          );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Location saved successfully')),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    addressController.dispose();
    landmarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vendor Location')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: isLoading ? null : getCurrentLocation,
              icon: const Icon(Icons.my_location),
              label: const Text('Use Current Location'),
            ),

            const SizedBox(height: 24),

            if (latitude != null && longitude != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Latitude: $latitude'),
                      const SizedBox(height: 8),
                      Text('Longitude: $longitude'),
                      const SizedBox(height: 12),

                      if (hasLoadedData)
                        const Text(
                          'Current Saved Location',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 20),

            TextField(
              controller: addressController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: landmarkController,
              decoration: const InputDecoration(
                labelText: 'Landmark (Optional)',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : saveLocation,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Save Location'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
