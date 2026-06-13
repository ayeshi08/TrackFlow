
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../model/trip_model.dart';
//
// class APIService {
//   final String baseUrl = "http://192.168.1.5:3000/trips";
//
//   // ==============================
//   // Start Trip
//   Future<Trip?> startTrip(Trip trip) async {
//     final body = {
//       "startTime": trip.startTime.toIso8601String(),
//       "distance": 0,
//       "duration": 0,
//       "startLat": trip.route.isNotEmpty ? trip.route.first.lat : 0,
//       "startLng": trip.route.isNotEmpty ? trip.route.first.lng : 0,
//     };
//
//     final response = await http
//         .post(
//       Uri.parse(baseUrl),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode(body),
//     )
//         .timeout(const Duration(seconds: 8));
//
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       final data = jsonDecode(response.body);
//       final tripData = data["trip"];
//       return Trip.fromJson(tripData);
//     }
//
//     return null;
//   }
//
//   // ==============================
//   // Get All Trips
//   Future<List<Trip>> fetchTrips() async {
//     final response = await http
//         .get(Uri.parse(baseUrl))
//         .timeout(const Duration(seconds: 8));
//
//     if (response.statusCode == 200) {
//       final List data = jsonDecode(response.body);
//       return data.map((e) => Trip.fromJson(e)).toList();
//     }
//
//     return [];
//   }
//
//   // ==============================
//   // Stop Trip
//   // FIX BUG 2: endTime is now passed in from the caller instead of
//   // calling DateTime.now() here, which would record the wrong end time
//   Future<void> stopTrip(Trip trip, {DateTime? endTime}) async {
//     // Use the passed endTime, fall back to trip.endTime, last resort is now
//     final resolvedEndTime = endTime ?? trip.endTime ?? DateTime.now();
//
//     final body = {
//       "endTime": resolvedEndTime.toIso8601String(),
//       "distance": trip.distance,
//       "duration": resolvedEndTime.difference(trip.startTime).inSeconds,
//       "avgSpeed": trip.avgSpeed,
//       "endLat": trip.route.isNotEmpty ? trip.route.last.lat : 0,
//       "endLng": trip.route.isNotEmpty ? trip.route.last.lng : 0,
//       "isValid": trip.isValid ?? true,
//       "invalidReason": trip.invalidReason ?? "",
//       "route": trip.route
//           .map((p) => {
//         "lat": p.lat,
//         "lng": p.lng,
//       })
//           .toList(),
//     };
//
//     final response = await http
//         .put(
//       Uri.parse("$baseUrl/${trip.id}"),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode(body),
//     )
//         .timeout(const Duration(seconds: 8));
//
//     if (response.statusCode != 200) {
//       throw Exception("Failed to update trip: ${response.statusCode}");
//     }
//   }
//
//   // ==============================
//   // Delete Trip
//   Future<void> deleteTrip(String id) async {
//     await http
//         .delete(Uri.parse("$baseUrl/$id"))
//         .timeout(const Duration(seconds: 8));
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/trip_model.dart';
import 'auth_service.dart';

class APIService {
  final String baseUrl = "https://trip-backend-production-a330.up.railway.app/trips";
  final AuthService _authService = AuthService();

  // ==============================
  // Get auth headers with JWT token
  Future<Map<String, String>> _getHeaders() async {
    final token = await _authService.getToken();
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  // ==============================
  // Start Trip
  Future<Trip?> startTrip(Trip trip) async {
    final headers = await _getHeaders();

    final body = {
      "startTime": trip.startTime.toIso8601String(),
      "distance": 0,
      "duration": 0,
      "startLat": trip.route.isNotEmpty ? trip.route.first.lat : 0,
      "startLng": trip.route.isNotEmpty ? trip.route.first.lng : 0,
    };

    final response = await http
        .post(
      Uri.parse(baseUrl),
      headers: headers,
      body: jsonEncode(body),
    )
        .timeout(const Duration(seconds: 8));

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final tripData = data["trip"];
      return Trip.fromJson(tripData);
    }

    return null;
  }

  // ==============================
  // Get All Trips (only returns trips for logged-in user)
  Future<List<Trip>> fetchTrips() async {
    final headers = await _getHeaders();

    final response = await http
        .get(Uri.parse(baseUrl), headers: headers)
        .timeout(const Duration(seconds: 8));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Trip.fromJson(e)).toList();
    }

    return [];
  }

  // ==============================
  // Stop Trip — endTime passed in from caller, never DateTime.now() here
  Future<void> stopTrip(Trip trip, {DateTime? endTime}) async {
    final headers = await _getHeaders();
    final resolvedEndTime = endTime ?? trip.endTime ?? DateTime.now();

    final body = {
      "endTime": resolvedEndTime.toIso8601String(),
      "distance": trip.distance,
      "duration": resolvedEndTime.difference(trip.startTime).inSeconds,
      "avgSpeed": trip.avgSpeed,
      "endLat": trip.route.isNotEmpty ? trip.route.last.lat : 0,
      "endLng": trip.route.isNotEmpty ? trip.route.last.lng : 0,
      "isValid": trip.isValid ?? true,
      "invalidReason": trip.invalidReason ?? "",
      "route": trip.route
          .map((p) => {"lat": p.lat, "lng": p.lng})
          .toList(),
    };

    final response = await http
        .put(
      Uri.parse("$baseUrl/${trip.id}"),
      headers: headers,
      body: jsonEncode(body),
    )
        .timeout(const Duration(seconds: 8));

    if (response.statusCode != 200) {
      throw Exception("Failed to update trip: ${response.statusCode}");
    }
  }

  // ==============================
  // Delete Trip
  Future<void> deleteTrip(String id) async {
    final headers = await _getHeaders();

    await http
        .delete(Uri.parse("$baseUrl/$id"), headers: headers)
        .timeout(const Duration(seconds: 8));
  }
}