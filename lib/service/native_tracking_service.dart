import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';

class NativeTrackingService {
  static const _methodChannel = MethodChannel('com.trackflow.app/tracking');
  static const _eventChannel = EventChannel('com.trackflow.app/location');

  StreamSubscription? _subscription;
  final void Function(Map<String, dynamic> data) onLocationUpdate;

  NativeTrackingService({required this.onLocationUpdate});

  Future<void> startTracking() async {
    await _methodChannel.invokeMethod('startTracking');
    _subscription = _eventChannel.receiveBroadcastStream().listen((event) {
      try {
        final data = jsonDecode(event as String) as Map<String, dynamic>;
        onLocationUpdate(data);
      } catch (e) {
        // ignore parse errors
      }
    });
  }

  Future<void> stopTracking() async {
    await _subscription?.cancel();
    _subscription = null;
    await _methodChannel.invokeMethod('stopTracking');
  }

  Future<void> pause() async {
    await _methodChannel.invokeMethod('pauseTracking');
  }

  Future<void> resume() async {
    await _methodChannel.invokeMethod('resumeTracking');
  }

  void dispose() {
    _subscription?.cancel();
  }
}
