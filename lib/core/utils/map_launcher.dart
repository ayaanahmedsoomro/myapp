import 'package:url_launcher/url_launcher.dart';

Future<void> launchMap(String source, String destination) async {
  final Uri googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&origin=$source&destination=$destination&travelmode=driving');

  print('Trying to launch: $googleMapsUrl');

  if (await canLaunchUrl(googleMapsUrl)){
    print('Launching map...');
    await launchUrl(googleMapsUrl);
  } else {
    print('Could not launch map. Make sure Google Maps is installed.');
  }
}