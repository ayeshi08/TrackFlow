import 'package:flutter_foreground_task/flutter_foreground_task.dart';

class BackgroundService {

  static void init() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'trackflow_gps_channel',
        channelName: 'TrackFlow GPS Tracking',
        channelDescription: 'Keeps GPS running while tracking your trip',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(5000),
        autoRunOnBoot: false,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  static Future<void> startTracking() async {
    if (await FlutterForegroundTask.isRunningService) return;

    await FlutterForegroundTask.startService(
      serviceId: 256,
      notificationTitle: 'TrackFlow is tracking your trip',
      notificationText: 'GPS is active. Your route is being recorded.',
      callback: startCallback,
    );
  }

  static Future<void> stopTracking() async {
    await FlutterForegroundTask.stopService();
  }

  static Future<void> requestPermissions() async {
    final notificationPermission =
    await FlutterForegroundTask.checkNotificationPermission();
    if (notificationPermission != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }
  }
}

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(TripTaskHandler());
}

class TripTaskHandler extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {}

  @override
  void onRepeatEvent(DateTime timestamp) {
    FlutterForegroundTask.updateService(
      notificationTitle: 'TrackFlow is tracking your trip',
      notificationText: 'GPS active — tap to open app',
    );
  }

  @override
  Future<void> onDestroy(DateTime timestamp) async {}
}