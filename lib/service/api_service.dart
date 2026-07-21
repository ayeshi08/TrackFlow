import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/trip_model.dart';
import 'auth_service.dart';

class APIService {
  // final String baseUrl = AppConfig.baseUrl;
  final String baseUrl =
      "https://trip-backend-production-a330.up.railway.app/trips";
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

  // Save Trip (single call — replaces startTrip + stopTrip)
  Future<Trip?> saveTrip(Trip trip, {required int durationSeconds}) async {
    final headers = await _getHeaders();

    final body = {
      "startTime": trip.startTime.toIso8601String(),
      "endTime": trip.endTime?.toIso8601String(),
      "distance": trip.distance,
      "duration": durationSeconds,
      "avgSpeed": trip.avgSpeed,
      "startLat": trip.startLat,
      "startLng": trip.startLng,
      "endLat": trip.endLat,
      "endLng": trip.endLng,
      "route": trip.route.map((p) => {"lat": p.lat, "lng": p.lng}).toList(),
    };

    final response = await http
        .post(Uri.parse(baseUrl), headers: headers, body: jsonEncode(body))
        .timeout(const Duration(seconds: 8));

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final tripData = data["trip"];
      return Trip.fromJson(tripData);
    }

    return null;
  }

  Future<void> deleteTrip(String id) async {
    final headers = await _getHeaders();

    await http
        .delete(Uri.parse("$baseUrl/$id"), headers: headers)
        .timeout(const Duration(seconds: 8));
  }
}
