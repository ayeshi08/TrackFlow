import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/trip_model.dart';

class StorageService {
  static const _tripsKey = 'trips';
  static const _inProgressTripKey = 'in_progress_trip';
  // Get all locally stored trips
  Future<List<Trip>> getTrips() async {
    final prefs = await SharedPreferences.getInstance();
    final localData = prefs.getString(_tripsKey);

    if (localData == null) return [];

    final List jsonData = jsonDecode(localData);
    return jsonData.map((e) => Trip.fromJson(e)).toList();
  }

  // ==============================
  // Overwrite the entire trips list
  Future<void> saveTrips(List<Trip> trips) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _tripsKey,
      jsonEncode(trips.map((t) => t.toJson()).toList()),
    );
  }

  // ==============================
  // Add or update a trip (upsert by id)
  Future<void> addTrip(Trip trip) async {
    final trips = await getTrips();
    final index = trips.indexWhere((t) => t.id == trip.id);

    if (index != -1) {
      trips[index] = trip;
    } else {
      trips.add(trip);
    }

    await saveTrips(trips);
  }

  // ==============================
  // Update an existing trip in place
  Future<void> updateTrip(Trip trip) async {
    final trips = await getTrips();
    final index = trips.indexWhere((t) => t.id == trip.id);

    if (index != -1) {
      trips[index] = trip;
      await saveTrips(trips);
    }
  }

  // Save current in-progress trip (checkpoint)
  Future<void> saveInProgressTrip(Trip trip) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_inProgressTripKey, jsonEncode(trip.toJson()));
  }

  // ==============================
  // Get the in-progress trip, if any exists (after a crash)
  Future<Trip?> getInProgressTrip() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_inProgressTripKey);
    if (data == null) return null;
    return Trip.fromJson(jsonDecode(data));
  }

  // ==============================
  //Clear the checkpoint (call this once a trip finishes normally)
  Future<void> clearInProgressTrip() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_inProgressTripKey);
  }

  // ==============================
  // Delete a trip by id
  Future<void> deleteTrip(String id) async {
    final trips = await getTrips();
    trips.removeWhere((t) => t.id == id);
    await saveTrips(trips);
  }

  // ==============================
  // Wipe all local trips — use with caution
  Future<void> clearTrips() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tripsKey);
  }
}
