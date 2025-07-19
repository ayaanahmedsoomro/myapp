import 'package:flutter/material.dart';
import 'package:myapp/features/maps/screens/map_home.dart';
import 'package:myapp/features/maps/screens/music_home.dart';
import 'package:myapp/features/maps/widgets/main_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Robot App'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            MainButton(text: "Google Map", icon: Icon(Icons.location_on), screen: MapHomeScreen()),
            const SizedBox(height: 20,),
            MainButton(text: "Music", icon: Icon(Icons.music_note), screen: MusicHomeScreen()), 
          ],
        ),
      ),
    );
  }
}


