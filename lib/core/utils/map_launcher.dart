import 'package:url_launcher/url_launcher.dart';

Future<void> launchMap(
  String source,
  String destination, {
  required bool navigate,
}) async {
  final url =
      'https://www.google.com/maps/dir/?api=1&origin=$source&destination=$destination&travelmode=driving${navigate ? '&navigate=yes' : ''}';
  final uri = Uri.parse(url);

  try {
    // Try external app (Maps)
    if (await launchUrl(uri, mode: LaunchMode.externalNonBrowserApplication)) {
      print("Launched via external app");
    }
    // If fails, fallback to browser
    else if (await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      print("Launched in browser");
    } else {
      print("Could not launch");
    }
  } catch (e) {
    print("Error launching URL: $e");
  }
}
