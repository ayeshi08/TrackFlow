package com.nexora.trackflow

import android.app.*
import android.content.Intent
import android.os.IBinder
import android.os.Looper
import androidx.core.app.NotificationCompat
import com.google.android.gms.location.*
import org.json.JSONObject
import com.nexora.trackflow.R

class TrackingService : Service() {

    private lateinit var fusedLocationClient: FusedLocationProviderClient
    private lateinit var locationCallback: LocationCallback

    private var totalDistanceMeters = 0.0
    private var lastLat: Double? = null
    private var lastLng: Double? = null
    private var isPaused = false

    companion object {
        const val CHANNEL_ID = "trackflow_gps_channel"
        const val NOTIFICATION_ID = 1001
        var eventSink: io.flutter.plugin.common.EventChannel.EventSink? = null
    }

    override fun onCreate() {
        super.onCreate()
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when (intent?.action) {
            "START" -> startTracking()
            "STOP" -> stopSelf()
            "PAUSE" -> isPaused = true
            "RESUME" -> isPaused = false
        }
        return START_STICKY
    }

    private fun startTracking() {
        startForeground(NOTIFICATION_ID, buildNotification("0.00 km"))

        val request = LocationRequest.Builder(
            Priority.PRIORITY_HIGH_ACCURACY, 3000L
        ).apply {
            setMinUpdateDistanceMeters(2f)
            setWaitForAccurateLocation(false)
        }.build()

        locationCallback = object : LocationCallback() {
            override fun onLocationResult(result: LocationResult) {
                if (isPaused) return
                val location = result.lastLocation ?: return
                if (location.accuracy > 30f) return

                val lat = location.latitude
                val lng = location.longitude

                if (lastLat != null && lastLng != null) {
                    val distance = FloatArray(1)
                    android.location.Location.distanceBetween(
                        lastLat!!, lastLng!!, lat, lng, distance
                    )
                    val meters = distance[0].toDouble()
                    val noiseFloor = location.accuracy.coerceIn(3f, 10f)

                    if (meters > noiseFloor && meters < 200) {
                        totalDistanceMeters += meters
                    }
                }

                lastLat = lat
                lastLng = lng
            } // <-- Fixed: Closed onLocationResult
        } // <-- Fixed: Closed LocationCallback object

        try {
            fusedLocationClient.requestLocationUpdates(
                request,
                locationCallback,
                Looper.getMainLooper()
            )
        } catch (e: SecurityException) {
            stopSelf()
        }
    }

    private fun createNotificationChannel() {
        val channel = NotificationChannel(
            CHANNEL_ID,
            "GPS Tracking",
            NotificationManager.IMPORTANCE_LOW
        ).apply {
            description = "Shown while a trip is being recorded"
            setShowBadge(false)
        }
        val manager = getSystemService(NotificationManager::class.java)
        manager?.createNotificationChannel(channel)
    }

    private fun buildNotification(text: String): Notification {
        val intent = Intent(this, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(
            this, 0, intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("TrackFlow — trip in progress")
            .setContentText(text)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentIntent(pendingIntent)
            .setOngoing(true)
            .setSilent(true)
            .build()
    }

    private fun updateNotification(text: String) {
        val notification = buildNotification(text)
        val manager = getSystemService(NotificationManager::class.java)
        manager?.notify(NOTIFICATION_ID, notification)
    }

    override fun onDestroy() {
        super.onDestroy()
        if (::locationCallback.isInitialized) {
            fusedLocationClient.removeLocationUpdates(locationCallback)
        }
        // Reset state
        totalDistanceMeters = 0.0
        lastLat = null
        lastLng = null
        isPaused = false
        eventSink = null
    }

    override fun onBind(intent: Intent?): IBinder? = null
}