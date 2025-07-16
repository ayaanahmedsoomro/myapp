import 'package:flutter/material.dart';
// import 'package:controlling_app/features/maps/controllers/location_controller.dart';
// import 'package:controlling_app/features/maps/widgets/location_input_field.dart';
// import 'package:controlling_app/features/maps/widgets/show_route_button.dart';
import 'package:myapp/features/maps/controllers/location_controller.dart';
import 'package:myapp/features/maps/widgets/location_input_field.dart';
import 'package:myapp/features/maps/widgets/show_route_button.dart';

class MapHomeScreen extends StatefulWidget {
  const MapHomeScreen({super.key});

  @override
  State<MapHomeScreen> createState() => _MapHomeScreenState();
}

class _MapHomeScreenState extends State<MapHomeScreen> {
  final LocationController _controller = LocationController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Controlling App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            LocationInputField(
              controller: _controller.sourceController,
              label: 'Source Location',
            ),
            const SizedBox(height: 16.0),
            LocationInputField(
              controller: _controller.destinationController,
              label: 'Destination Location',
            ),
            const SizedBox(height: 24.0),
            ShowRouteButton(
              onPressed: _controller.launchRoute,
            ),
          ],
        ),
      ),
    );
  }
}