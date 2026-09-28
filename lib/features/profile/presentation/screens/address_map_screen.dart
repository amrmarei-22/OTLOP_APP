import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressMapScreen extends StatefulWidget {
  const AddressMapScreen({super.key});

  @override
  State<AddressMapScreen> createState() => _AddressMapScreenState();
}

class _AddressMapScreenState extends State<AddressMapScreen> {
  GoogleMapController? _mapController;
  LatLng? _currentLocation;
  String _address = 'Finding your address...';
  String? _errorMessage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAddress();
  }

  Future<void> _loadAddress() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw const _AddressException('Please enable location services.');
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        throw const _AddressException('Location permission was denied.');
      }
      if (permission == LocationPermission.deniedForever) {
        throw const _AddressException(
          'Location permission is disabled in Settings.',
        );
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      final location = LatLng(position.latitude, position.longitude);
      final placemarks = await Geocoding().placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      final place = placemarks.isEmpty ? null : placemarks.first;
      final addressParts = [
        place?.street,
        place?.subLocality,
        place?.locality,
        place?.country,
      ].whereType<String>().where((part) => part.trim().isNotEmpty).toSet();

      if (mounted) {
        setState(() {
          _currentLocation = location;
          _address = addressParts.isEmpty
              ? 'Current location'
              : addressParts.join(', ');
          _isLoading = false;
        });
        await _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(location, 16),
        );
      }
    } on _AddressException catch (error) {
      _setError(error.message);
    } catch (_) {
      _setError('Unable to reach your current address. Please try again.');
    }
  }

  void _setError(String message) {
    if (!mounted) return;
    setState(() {
      _errorMessage = message;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final location = _currentLocation;

    return Scaffold(
      appBar: AppBar(title: const Text('My Address')),
      body: Stack(
        children: [
          if (location != null)
            GoogleMap(
              initialCameraPosition: CameraPosition(target: location, zoom: 16),
              markers: {
                Marker(
                  markerId: const MarkerId('current-address'),
                  position: location,
                  infoWindow: InfoWindow(title: _address),
                ),
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onMapCreated: (controller) => _mapController = controller,
            )
          else
            Center(
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Text(
                      _errorMessage ?? 'Address unavailable',
                      textAlign: TextAlign.center,
                    ),
            ),
          if (location != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 24,
              child: Material(
                color: colorScheme.surface,
                elevation: 4,
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.location_on, color: colorScheme.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _address,
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (_errorMessage != null && location == null)
            Positioned(
              left: 24,
              right: 24,
              bottom: 32,
              child: FilledButton.icon(
                onPressed: () {
                  setState(() {
                    _errorMessage = null;
                    _isLoading = true;
                  });
                  _loadAddress();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Try again'),
              ),
            ),
        ],
      ),
    );
  }
}

class _AddressException implements Exception {
  const _AddressException(this.message);

  final String message;
}
