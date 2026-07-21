package com.nexora.trackflow

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    companion object {
        const val METHOD_CHANNEL = "com.trackflow.app/tracking"
        const val EVENT_CHANNEL = "com.trackflow.app/location"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Method channel — start/stop/pause/resume commands
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            METHOD_CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "startTracking" -> {
                    val intent = Intent(this, TrackingService::class.java)
                        .apply { action = "START" }
                    startForegroundService(intent)
                    result.success(null)
                }
                "stopTracking" -> {
                    val intent = Intent(this, TrackingService::class.java)
                        .apply { action = "STOP" }
                    startService(intent)
                    result.success(null)
                }
                "pauseTracking" -> {
                    val intent = Intent(this, TrackingService::class.java)
                        .apply { action = "PAUSE" }
                    startService(intent)
                    result.success(null)
                }
                "resumeTracking" -> {
                    val intent = Intent(this, TrackingService::class.java)
                        .apply { action = "RESUME" }
                    startService(intent)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }

        // Event channel — receives GPS data from Kotlin → Flutter
        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            EVENT_CHANNEL
        ).setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, sink: EventChannel.EventSink) {
                TrackingService.eventSink = sink
            }
            override fun onCancel(arguments: Any?) {
                TrackingService.eventSink = null
            }
        })
    }
}