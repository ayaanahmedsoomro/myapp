import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationInputField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool showUseCurrentLocationButton;

  const LocationInputField({
    super.key,
    required this.controller,
    required this.label,
    this.showUseCurrentLocationButton = false,
  });

  @override
  State<LocationInputField> createState() => _LocationInputFieldState();
}

class _LocationInputFieldState extends State<LocationInputField> {
  Future<void> _useCurrentLocation() async {
    // 1. Request location permission
    PermissionStatus permissionStatus = await Permission.location.request();

    if (permissionStatus.isGranted) {
      try {
        // 2. Get current position
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        // 3. Use geocoding to get address
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        // 4. Autofill sourceController with formatted address
        if (placemarks.isNotEmpty) {
          Placemark placemark = placemarks.first;
          String address =
              '${placemark.street}, ${placemark.locality}, ${placemark.country}';
          widget.controller.text = address;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not find address for location.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error getting location: $e')),
        );
      }
    } else {
      // 5. Show user-friendly message if permission not granted
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission not granted.')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: widget.label,
          border: const OutlineInputBorder(),
          suffixIcon: widget.showUseCurrentLocationButton
              ? IconButton(
                  icon: const Icon(Icons.my_location),
                  onPressed: _useCurrentLocation,
                )
              : null,
        ),
      ),
    );
  }
}