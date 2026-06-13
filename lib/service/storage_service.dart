
// import 'dart:convert';
//
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../model/trip_model.dart';
//
// class StorageService {
//   final String apiBaseUrl = "http://192.168.1.5:3000/trips";
//
//   Future<List<Trip>> getTrips() async {
//     final prefs = await SharedPreferences.getInstance();
//     final localData = prefs.getString('trips');
//
//     if (localData == null) return [];
//
//     final List jsonData = jsonDecode(localData);
//     return jsonData.map((e) => Trip.fromJson(e)).toList();
//   }
//
//   Future<void> saveTrips(List<Trip> trips) async {
//     final prefs = await SharedPreferences.getInstance();
//
//     await prefs.setString(
//       'trips',
//       jsonEncode(trips.map((t) => t.toJson()).toList()),
//     );
//   }
//
//   Future<void> addTrip(Trip trip) async {
//     final trips = await getTrips();
//
//     final index = trips.indexWhere((t) => t.id == trip.id);
//
//     if (index != -1) {
//       trips[index] = trip;
//     } else {
//       trips.add(trip);
//     }
//
//     await saveTrips(trips);
//   }
//   Future<void> clearTrips() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('trips');
//   }
//
//   Future<void> updateTrip(Trip trip) async {
//     final trips = await getTrips();
//
//     final index = trips.indexWhere((t) => t.id == trip.id);
//
//     if (index != -1) {
//       trips[index] = trip;
//       await saveTrips(trips);
//     }
//   }
//
//   Future<void> deleteTrip(String id) async {
//     final trips = await getTrips();
//     trips.removeWhere((t) => t.id == id);
//     await saveTrips(trips);
//   }
// }
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/trip_model.dart';

class StorageService {
  static const _tripsKey = 'trips';
 // final String apiBaseUrl = "http://192.168.1.5:3000/trips";
  // ==============================
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