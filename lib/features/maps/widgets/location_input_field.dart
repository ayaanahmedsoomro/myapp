// location_input_field.dart
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

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
  bool isLoading = false;

  Future<void> _useCurrentLocation() async {
    setState(() => isLoading = true);

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enable location services.')),
        );
        setState(() => isLoading = false);
        return;
      }

      // Request permission (this shows native pop-up)
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission permanently denied. Please enable it in settings.')),
        );
        setState(() => isLoading = false);
        return;
      }

      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark placemark = placemarks.first;
          String address = '${placemark.street}, ${placemark.locality}, ${placemark.country}';
          widget.controller.text = address;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not find address for location.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission not granted.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: $e')),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: widget.showUseCurrentLocationButton
            ? IconButton(
                icon: isLoading
                    ? const CircularProgressIndicator()
                    : const Icon(Icons.my_location),
                onPressed: isLoading ? null : _useCurrentLocation,
              )
            : null,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
