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
  bool isLoading = false;

  Future<void> _useCurrentLocation() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Check if permission is already granted
      if (await Permission.location.isDenied ||
          await Permission.location.isPermanentlyDenied) {
        // Request permission
        PermissionStatus status = await Permission.location.request();

        // If denied permanently, direct user to app settings
        if (status.isPermanentlyDenied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Location permission permanently denied. Please enable it from app settings.',
                ),
              ),
            );
          }
          openAppSettings();
          setState(() => isLoading = false);
          return;
        }

        // If still denied, exit
        if (!status.isGranted) {
          setState(() => isLoading = false);
          return;
        }
      }

      // Get location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Get address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        String address =
            '${placemark.street}, ${placemark.locality}, ${placemark.country}';
        if (mounted) {
          widget.controller.text = address;
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not find address for location.'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error getting location: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: widget.controller,
          decoration: InputDecoration(
            labelText: widget.label,
            suffixIcon:
                widget.showUseCurrentLocationButton
                    ? IconButton(
                      icon:
                          isLoading
                              ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : const Icon(Icons.my_location),
                      onPressed: isLoading ? null : _useCurrentLocation,
                    )
                    : null,
          ),
        ),
      ],
    );
  }
}
