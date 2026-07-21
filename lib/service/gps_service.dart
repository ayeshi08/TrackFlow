import 'package:geolocator/geolocator.dart';

class GPSService {
  Future<String?> requestPermission() async {
    // Check GPS on
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return "GPS_OFF";

    // Check current status
    LocationPermission permission = await Geolocator.checkPermission();

    // Already has always permission — perfect
    if (permission == LocationPermission.always) return null;

    // Permanently denied — needs Settings
    if (permission == LocationPermission.deniedForever) return "DENIED_FOREVER";

    // Request permission — shows ONE system dialog
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // After requesting
    if (permission == LocationPermission.always) return null;
    if (permission == LocationPermission.deniedForever) return "DENIED_FOREVER";
    if (permission == LocationPermission.denied) return "DENIED";

    // whileInUse — trip starts with warning
    if (permission == LocationPermission.whileInUse) return "BACKGROUND_ONLY";

    return "DENIED";
  }

  Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(
      locationSettings: AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 2, // reduced from 5 — catch more points
        intervalDuration: const Duration(seconds: 2), // reduced from 3
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationTitle: 'TrackFlow is tracking',
          notificationText: 'Your trip is being recorded',
          enableWakeLock: true,
          setOngoing: true, // prevents user from dismissing notification
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
