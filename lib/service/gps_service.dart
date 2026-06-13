//
// import 'package:geolocator/geolocator.dart';
//
// class GPSService {
//
//   Future<String?> requestPermission() async {
//
//     /// 1. Check if GPS is ON
//     bool serviceEnabled =
//     await Geolocator.isLocationServiceEnabled();
//
//     if (!serviceEnabled) {
//       return "GPS_OFF";
//     }
//
//     /// 2. Check app permission
//     LocationPermission permission =
//     await Geolocator.checkPermission();
//
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//     }
//
//     /// 3. Permission denied
//     if (permission == LocationPermission.denied) {
//       return "Location permission denied.";
//     }
//
//     /// 4. Permanently denied
//     if (permission == LocationPermission.deniedForever) {
//       return "Location permission permanently denied. Please enable it from settings.";
//     }
//
//     /// 5. Everything OK
//     return null;
//   }
//
//   Stream<Position> getPositionStream() {
//     return Geolocator.getPositionStream(
//       locationSettings: const LocationSettings(
//         accuracy: LocationAccuracy.high,
//         distanceFilter: 5,
//       ),
//     );
//   }
//
//   Future<Position> getCurrentPosition() async {
//     return await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );
//   }
// }

import 'package:geolocator/geolocator.dart';

class GPSService {

  Future<String?> requestPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return "GPS_OFF";

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) return "Location permission denied.";
    if (permission == LocationPermission.deniedForever) {
      return "Location permission permanently denied. Please enable it from settings.";
    }
    return null;
  }

  Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(
      locationSettings: AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
        intervalDuration: const Duration(seconds: 2),
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationTitle: 'TrackFlow is tracking',
          notificationText: 'Your trip is being recorded',
          enableWakeLock: true,
        ),
      ),
    );
  }

  // FIX: use last known position first for instant response, then get accurate one
  Future<Position> getCurrentPosition() async {
    // Try last known position first — instant, no delay
    final last = await Geolocator.getLastKnownPosition();
    if (last != null) return last;

    // Fall back to full GPS fix
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 10),
    );
  }
}