
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/lat_lng_point.dart';
import '../model/trip_model.dart';
import '../service/background_service.dart';
import '../service/gps_service.dart';
import '../service/api_service.dart';
import '../service/storage_service.dart';
import 'package:uuid/uuid.dart';


class HomeViewModel extends ChangeNotifier {
  final GPSService _gpsService = GPSService();
  final StorageService _storageService = StorageService();
  final APIService _apiService = APIService();

  Trip? currentTrip;
  LatLng? currentLocation;
  bool isTripActive = false;
  StreamSubscription? _locationSub;
  Timer? _timer;
  LatLng? _lastAddedPoint;
  DateTime? _lastUpdateTime;
  List<Trip> _trips = [];
  double weeklyDistance = 0;
  int weeklyTrips = 0;
  double currentSpeed = 0;
  double _lastSpeedDistance = 0;
  DateTime? _lastSpeedTime;
  LatLng? _lastSpeedPoint;
  bool _isSyncing = false;
  StreamSubscription? _connectivitySub;
  bool isSaving = false;

  List<Trip> get trips => _trips.where((t) => t.endTime != null).toList();

  HomeViewModel() {
    _init();
  }

  Future<void> loadTrips() async {
    final localTrips = await _storageService.getTrips();

    try {
      final serverTrips = await _apiService.fetchTrips();

      final Map<String, Trip> merged = {};

      // SERVER TRIPS go in first (source of truth)
      for (final trip in serverTrips) {
        merged[trip.id] = trip;
      }

      // Only add local trips that are NOT synced AND don't already
      // exist on the server (prevents duplicates from partial syncs)
      final serverIds = serverTrips.map((t) => t.id).toSet();
      for (final trip in localTrips) {
        if (trip.isSynced == false && !serverIds.contains(trip.id)) {
          merged[trip.id] = trip;
        }
      }

      _trips = merged.values.toList();

    } catch (e) {
      // OFFLINE — keep whatever was already loaded from server
      // and just add any new unsynced local trips on top.
      // This prevents history from collapsing to 1 trip when internet drops.
      final Map<String, Trip> merged = {};

      // Keep previously loaded trips (could be from server, already in memory)
      for (final trip in _trips) {
        merged[trip.id] = trip;
      }

      // Add any unsynced local trips not already in the list
      final existingIds = merged.keys.toSet();
      for (final trip in localTrips) {
        if (trip.isSynced == false && !existingIds.contains(trip.id)) {
          merged[trip.id] = trip;
        }
      }

      _trips = merged.values.toList();
    }

    _recalculateWeeklyStats();
    notifyListeners();
  }

  void _recalculateWeeklyStats() {
    weeklyTrips = 0;
    weeklyDistance = 0;

    final now = DateTime.now();
    final seen = <String>{};

    for (final t in _trips) {
      if (t.startTime.isAfter(now.subtract(const Duration(days: 7))) &&
          seen.add(t.id)) {
        weeklyTrips++;
        weeklyDistance += t.distance;
      }
    }
  }

  // ==============================
  // Start Trip
  Future<String?> startTrip() async {
    if (isTripActive) return null;

    final permissionError = await _gpsService.requestPermission();
    if (permissionError != null) return permissionError;

    isTripActive = true;

    await BackgroundService.startTracking();
    _lastAddedPoint = null;
    _lastSpeedPoint = null;
    _lastSpeedTime = null;
    currentSpeed = 0;

    currentTrip = Trip(
      id: const Uuid().v4(),
      startTime: DateTime.now(),
      route: [],
      distance: 0,
      isSynced: false,
    );

    final pos = await _gpsService.getCurrentPosition();

    currentLocation = LatLng(pos.latitude, pos.longitude);

    currentTrip!.startLat = pos.latitude;
    currentTrip!.startLng = pos.longitude;

    currentTrip!.route.add(
      LatLngPoint(lat: pos.latitude, lng: pos.longitude),
    );

    notifyListeners();

    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (_) {
        notifyListeners();
      },
    );

    _locationSub = _gpsService.getPositionStream().listen((position) {
      if (!isTripActive || currentTrip == null) return;

      final newLoc = LatLng(position.latitude, position.longitude);

      if (_lastAddedPoint == null ||
          _calculateDistance(_lastAddedPoint!, newLoc) > 0.002) {
        _addPoint(newLoc);
      }
    });

    return null;
  }

  // ==============================
  // Stop Trip
  // FIX BUG 1: check connectivity before attempting server save
  Future<void> stopTrip() async {
    if (!isTripActive) return;

    isTripActive = false;
    isSaving = true;
    notifyListeners();

    _locationSub?.cancel();
    _timer?.cancel();
    _timer = null;

    if (currentTrip == null) {
      isSaving = false;
      notifyListeners();
      return;
    }

    final endTime = DateTime.now();
    currentTrip!.endTime = endTime;

    if (currentTrip!.route.isNotEmpty) {
      currentTrip!.endLat = currentTrip!.route.last.lat;
      currentTrip!.endLng = currentTrip!.route.last.lng;
    }

    // ==============================
    // VALIDATION — check if trip is worth saving
    final durationSeconds = endTime
        .difference(currentTrip!.startTime)
        .inSeconds;
    final hasEnoughDistance = currentTrip!.distance >= 0.05;
    final hasEnoughDuration = durationSeconds >= 30;
    final hasEnoughPoints = currentTrip!.route.length >= 2;

    if (!hasEnoughDistance || !hasEnoughDuration || !hasEnoughPoints) {
      // Trip is too short — discard it completely
      _tripDiscardReason = _getDiscardReason(
        hasEnoughDistance: hasEnoughDistance,
        hasEnoughDuration: hasEnoughDuration,
        hasEnoughPoints: hasEnoughPoints,
      );

      currentTrip = null;
      currentLocation = null;
      isSaving = false;
      _lastAddedPoint = null;
      _lastSpeedPoint = null;
      _lastSpeedTime = null;
      currentSpeed = 0;
      notifyListeners();
      return;
    }

    currentTrip!.isValid = true;

    // Save online or offline
    final connectivityResult = await Connectivity().checkConnectivity();
    final isOnline = !connectivityResult.contains(ConnectivityResult.none);

    if (isOnline) {
      try {
        final createdTrip = await _apiService.startTrip(currentTrip!);
        if (createdTrip != null) {
          currentTrip!.id = createdTrip.id;
          await _apiService.stopTrip(currentTrip!, endTime: endTime);
          currentTrip!.isSynced = true;
        } else {
          throw Exception('Server returned null');
        }
      } catch (e) {
        currentTrip!.isSynced = false;
        await _storageService.addTrip(currentTrip!);
      }
    } else {
      currentTrip!.isSynced = false;
      await _storageService.addTrip(currentTrip!);
    }

    currentTrip = null;
    currentLocation = null;

    await loadTrips();

    _lastAddedPoint = null;
    _lastSpeedPoint = null;
    _lastSpeedTime = null;
    currentSpeed = 0;
    isSaving = false;
    notifyListeners();
  }

// ==============================
// Reason why trip was discarded
  String? _tripDiscardReason;
  String? get tripDiscardReason => _tripDiscardReason;

  void clearDiscardReason() {
    _tripDiscardReason = null;
    notifyListeners();
  }

  String _getDiscardReason({
    required bool hasEnoughDistance,
    required bool hasEnoughDuration,
    required bool hasEnoughPoints,
  }) {
    if (!hasEnoughPoints) return 'No GPS points recorded. Make sure location is enabled.';
    if (!hasEnoughDistance && !hasEnoughDuration) return 'Trip too short. Travel at least 50 meters for 30 seconds.';
    if (!hasEnoughDistance) return 'Distance too short. Travel at least 50 meters.';
    if (!hasEnoughDuration) return 'Trip too short. Trip must be at least 30 seconds.';
    return 'Trip was too short to save.';
  }

  String get duration {
    if (currentTrip == null) return "00:00:00";
    final end = currentTrip!.endTime ?? DateTime.now();
    final diff = end.difference(currentTrip!.startTime);
    final h = diff.inHours.toString().padLeft(2, '0');
    final m = (diff.inMinutes % 60).toString().padLeft(2, '0');
    final s = (diff.inSeconds % 60).toString().padLeft(2, '0');
    return "$h:$m:$s";
  }

  String get distanceText =>
      "${currentTrip?.distance.toStringAsFixed(2) ?? 0} km";

  double _deg2rad(double deg) => deg * pi / 180;

  double _calculateDistance(LatLng start, LatLng end) {
    const R = 6371;
    final dLat = _deg2rad(end.latitude - start.latitude);
    final dLon = _deg2rad(end.longitude - start.longitude);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg2rad(start.latitude)) *
            cos(_deg2rad(end.latitude)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  // ==============================
  // Delete Trip
  // FIX BUG 6: use _storageService.deleteTrip() instead of raw SharedPreferences write
  Future<void> deleteTripById(String id) async {
    try {
      await _apiService.deleteTrip(id);
    } catch (e) {
      // API delete failed — still remove locally
    }

    _trips.removeWhere((t) => t.id == id);

    // FIX: go through StorageService, not raw SharedPreferences
    await _storageService.deleteTrip(id);

    notifyListeners();
  }

  void setTrips(List<Trip> trips) {
    _trips = trips;
    _recalculateWeeklyStats();
    notifyListeners();
  }

  void _addPoint(LatLng point) {
    if (currentTrip == null || !isTripActive) return;

    final newLatLng = LatLng(point.latitude, point.longitude);
    final now = DateTime.now();

    if (_lastAddedPoint != null) {
      final dist = _calculateDistance(_lastAddedPoint!, newLatLng);

      if (dist < 0.002) return;

      currentTrip!.distance += dist;

      if (_lastSpeedPoint != null && _lastSpeedTime != null) {
        final timeDiff = now.difference(_lastSpeedTime!).inSeconds;
        if (timeDiff > 0) {
          currentSpeed = (dist / timeDiff) * 3600; // km/h
        }
      }
    }

    _lastAddedPoint = newLatLng;
    _lastSpeedPoint = newLatLng;
    _lastSpeedTime = now;

    currentTrip!.route.add(
      LatLngPoint(lat: newLatLng.latitude, lng: newLatLng.longitude),
    );

    notifyListeners();
  }

  Trip? getTripById(String id) {
    try {
      return _trips.firstWhere((trip) => trip.id == id);
    } catch (e) {
      return null;
    }
  }
  void addFakePoint() {
    if (currentLocation == null || currentTrip == null) return;
    final newPoint = LatLng(
      currentLocation!.latitude + 0.0005,
      currentLocation!.longitude + 0.0005,
    );
    _addPoint(newPoint);
    currentLocation = newPoint;
    notifyListeners();
  }
  Future<void> _init() async {
    await syncPendingTrips();
    await loadTrips();

    _connectivitySub?.cancel();
    _connectivitySub = Connectivity().onConnectivityChanged.listen((results) async {
      if (results.contains(ConnectivityResult.none)) return;

      await Future.delayed(const Duration(seconds: 2));

      if (_isSyncing) return;

      await syncPendingTrips();
    });
  }

  // ==============================
  // Sync Pending Trips
  // FIX BUG 3 + BUG 5: update trip.id with server ID before calling stopTrip
  Future<void> syncPendingTrips() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      final localTrips = await _storageService.getTrips();

      for (final trip in localTrips) {
        if (trip.isSynced == true) continue;

        try {
          final created = await _apiService.startTrip(trip);

          if (created == null) continue;

          final oldId = trip.id;

          // FIX BUG 5: update trip.id to the server MongoDB _id BEFORE
          // calling stopTrip, so the PUT goes to the correct endpoint
          trip.id = created.id;

          // Use the trip's stored endTime so we don't drift
          await _apiService.stopTrip(trip, endTime: trip.endTime);

          // Remove the locally stored copy using the OLD local id
          await _storageService.deleteTrip(oldId);
        } catch (e) {
          // This trip stays in local storage and will retry on next sync
        }
      }

      await loadTrips();
    } finally {
      _isSyncing = false;
    }
  }

  @override
  void dispose() {
    _connectivitySub?.cancel();
    _locationSub?.cancel();
    _timer?.cancel();
    super.dispose();
  }
}