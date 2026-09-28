// home_screen_header.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:otlop_app/core/theme/app_colors.dart';

class HomeScreenHeader extends StatefulWidget {
  const HomeScreenHeader({super.key});

  @override
  State<HomeScreenHeader> createState() => _HomeScreenHeaderState();
}

class _HomeScreenHeaderState extends State<HomeScreenHeader> {
  String _address = '14 Tahrir Square, Cairo';
  bool _isLoadingAddress = false;

  Future<void> _getCurrentAddress() async {
    if (_isLoadingAddress) return;

    setState(() => _isLoadingAddress = true);
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw const _LocationException('Please enable location services.');
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        throw const _LocationException('Location permission was denied.');
      }
      if (permission == LocationPermission.deniedForever) {
        throw const _LocationException(
          'Location permission is disabled in Settings.',
        );
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          // timeLimit: Duration(seconds: 10),
        ),
      );
      final placemarks = await Geocoding().placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isEmpty) {
        throw const _LocationException('Could not find an address here.');
      }

      final place = placemarks.first;
      final addressParts = [
        place.street,
        place.subLocality,
        place.locality,
        place.country,
      ].whereType<String>().where((part) => part.trim().isNotEmpty).toList();

      if (addressParts.isEmpty) {
        throw const _LocationException('Could not find an address here.');
      }

      if (mounted) {
        setState(() => _address = addressParts.toSet().join(', '));
      }
    } on _LocationException catch (error) {
      if (mounted) _showLocationMessage(error.message);
    } catch (e) {
      log('Error getting current address: $e');
      if (mounted) {
        _showLocationMessage('Unable to get your current address.');
      }
    } finally {
      if (mounted) setState(() => _isLoadingAddress = false);
    }
  }

  void _showLocationMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Good evening 🥐",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  "Amro",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            IconButton(
              // color: colorScheme.onSurface,
              style: IconButton.styleFrom(
                backgroundColor: colorScheme.surfaceContainerHighest,
                padding: EdgeInsets.all(16),
              ),
              onPressed: () {},
              icon: SvgPicture.asset(
                'assets/icons/notification_icon.svg',
                colorFilter: ColorFilter.mode(
                  colorScheme.onSurface,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        InkWell(
          onTap: _getCurrentAddress,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outline, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 6,
              children: [
                Icon(Icons.location_on, color: colorScheme.primary, size: 20),
                Expanded(
                  child: Text(
                    _isLoadingAddress ? 'Finding your address...' : _address,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                Icon(Icons.arrow_drop_down, color: colorScheme.primary),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        TextField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search, color: colorScheme.onSurfaceVariant),
            hintText: 'Search coffee, cakes, donuts...',
            hintStyle: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 14,
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: colorScheme.surface,
                ),
                onPressed: () {},
                icon: SvgPicture.asset(
                  'assets/icons/filter_icon.svg',
                  colorFilter: ColorFilter.mode(
                    colorScheme.onSurface,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: colorScheme.outline, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ],
    );
  }
}

class _LocationException implements Exception {
  const _LocationException(this.message);

  final String message;
}
