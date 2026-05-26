import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:blood_bank/core/constants/app_colors.dart';
import 'package:blood_bank/core/widgets/primary_button.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  String? _locationName;
  LatLng _currentLatLng = const LatLng(30.0444, 31.2357);
  bool _loading = false;

  late final MapController _mapController;
  final TextEditingController _addressController = TextEditingController();

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getLocation();
  }

  Future<void> _getLocation() async {
    setState(() => _loading = true);

    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permission permanently denied');
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
        timeLimit: const Duration(seconds: 10),
      );

      _currentLatLng = LatLng(position.latitude, position.longitude);

      await _getAddressFromLocation(_currentLatLng);

      if (mounted) {
        _mapController.move(_currentLatLng, 18);
        setState(() {});
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _getAddressFromLocation(LatLng location) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        _locationName =
            '${place.street ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}';

        if (mounted) setState(() {});
      }
    } catch (_) {}
  }

  void _confirmLocation() {
    Navigator.pop(context, {
      'location': _locationName ?? 'Unknown location',
      'lat': _currentLatLng.latitude,
      'lng': _currentLatLng.longitude,
    });
  }

  @override
  void dispose() {
    _addressController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentLatLng,
              initialZoom: 18,
              minZoom: 1,
              maxZoom: 19,
              onPositionChanged: (position, _) {
                _currentLatLng = position.center ?? _currentLatLng;

                _debounce?.cancel();

                _debounce = Timer(
                  const Duration(milliseconds: 800),
                  () async {
                    await _getAddressFromLocation(_currentLatLng);
                  },
                );
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://a.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png',
                userAgentPackageName:
                    'com.example.graduation_project',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _currentLatLng,
                    width: 80,
                    height: 80,
                    child: Icon(
                      Icons.location_on,
                      color: AppColors.primary,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),

          Positioned(
            top: 20,
            right: 20,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              onPressed: _getLocation,
              child: const Icon(
                Icons.my_location,
                color: Colors.red,
              ),
            ),
          ),

          const Center(
            child: Icon(
              Icons.location_on,
              color: Colors.red,
              size: 40,
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _locationName ?? 'Loading...',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  PrimaryButton(
                    text: 'Confirm Location',
                    onPressed: _confirmLocation,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}