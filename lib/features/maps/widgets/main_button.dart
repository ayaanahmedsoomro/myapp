import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final String text;
  final Icon icon;
  final Widget screen;

  const MainButton({
    super.key,
    required this.text,
    required this.icon,
    required this.screen,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      icon: icon,
      label: Text(text),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(fontSize: 18),
      ),
    );
  }
}
