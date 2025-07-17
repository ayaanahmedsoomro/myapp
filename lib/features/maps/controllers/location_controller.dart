import 'package:flutter/material.dart';
import 'package:myapp/core/utils/map_launcher.dart';
// import '../../core/utils/map_launcher.dart';

class LocationController {
  final TextEditingController sourceController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  
  void launchNavigation({required bool autoStart}) {
    final source = sourceController.text;
    final destination = destinationController.text;

    if (source.isNotEmpty && destination.isNotEmpty) {
      launchMap(source, destination, navigate: autoStart);

    }
  }

  void changeDestination({required String newDestination}) {
    final source = sourceController.text;

    if (newDestination.isNotEmpty) {
      launchMap(source, newDestination, navigate: true);
    }
  }

  void updateDestination({required String newDestination}) {
    if (newDestination.isNotEmpty) {
      // Launch map with empty source to use current location as start
      launchMap("", newDestination, navigate: true);
    }
  }

  void dispose() {
    sourceController.dispose();
    destinationController.dispose();
  }

  void launchRoute({required bool autoStart}) {}
}
