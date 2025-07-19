import 'package:flutter/material.dart';
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
  bool _autoStartNavigation = true;
  final TextEditingController _updateDestinationController = TextEditingController();

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              LocationInputField(
                controller: _controller.sourceController,
                showUseCurrentLocationButton: true,
                label: 'Source Location',
              ),
              SizedBox(height: 16.0),
              LocationInputField(
                controller: _controller.destinationController,
                label: 'Destination Location',
              ),
              SizedBox(height: 16.0),  
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Start Navigation Automatically'),
                  Switch(
                    value: _autoStartNavigation,
                    onChanged: (newValue) {
                      setState(() {
                        _autoStartNavigation = newValue;
                      });
                    },
                  ),
                ],
              ),
              ShowRouteButton(
                onPressed: () => _controller.launchNavigation(autoStart: _autoStartNavigation),
              ),
              const SizedBox(height: 24.0),
              LocationInputField(
         controller: _updateDestinationController,
                label: 'New Destination',
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  final isNavigating = _controller.updateDestination(
                      newDestination: _updateDestinationController.text);
                  if (isNavigating) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Change Destination'),
                          content: const Text(
                              'You are already in navigation. Do you want to change the destination?'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('No'),
                              onPressed: () {
                                Navigator.of(context).pop(); // Dismiss dialog
                              },
                            ),
                            TextButton(
                              child: const Text('Yes'),
                              onPressed: () {
                                Navigator.of(context).pop(); // Dismiss dialog
                                _controller.updateDestination(
                                    newDestination: _updateDestinationController.text);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    _controller.updateDestination(
                        newDestination: _updateDestinationController.text);
                  }
                },
                child: const Text('Update Destination'),
              ),

            ],
          ),
        ),
      ),
    );
  }
}