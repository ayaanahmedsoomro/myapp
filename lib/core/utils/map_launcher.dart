import 'package:url_launcher/url_launcher.dart';

Future<void> launchMap(
 String source,
 String destination, {
 required bool navigate,
}) async {
 final Uri uri;

 if (navigate) {
    // Use navigation intent
    uri = Uri.parse('google.navigation:q=$destination');
  } else {
    // Use directions with origin and destination
    uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&origin=$source&destination=$destination&travelmode=driving',
    );
  }

  try {
    // Try launching in external map app
    if (await launchUrl(uri, mode: LaunchMode.externalNonBrowserApplication)) {
      print("Launched via external app");
    } else if (await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      print("Launched in browser");
    } else {
      print("Could not launch");
    }
  } catch (e) {
    print("Error launching URL: $e");
  }
}
