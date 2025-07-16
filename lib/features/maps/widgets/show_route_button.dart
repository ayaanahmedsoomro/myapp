import 'package:flutter/material.dart';

class ShowRouteButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ShowRouteButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: const Text('Show Route'),
    );
  }
}