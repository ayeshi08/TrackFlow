
import 'lat_lng_point.dart';
import 'package:uuid/uuid.dart';

class Trip {
  String id;
  DateTime startTime;
  DateTime? endTime;
  double distance;
  double avgSpeed;
  List<LatLngPoint> route;
  double startLat;
  double startLng;
  double endLat;
  double endLng;
  bool? isValid;
  String? invalidReason;
  bool isSynced;
  String status;

  Trip({
    required this.id,
    required this.startTime,
    this.endTime,
    this.distance = 0,
    this.avgSpeed = 0,
    this.route = const [],
    this.startLat = 0,
    this.startLng = 0,
    this.endLat = 0,
    this.endLng = 0,
    this.isValid,
    this.invalidReason,
    this.isSynced = false,
    this.status = "active",
  });

  // ==============================
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "startTime": startTime.toIso8601String(),
      "endTime": endTime?.toIso8601String(),
      "distance": distance,
      "avgSpeed": avgSpeed,
      "isValid": isValid,
      "invalidReason": invalidReason,
      "startLat": startLat,
      "startLng": startLng,
      "endLat": endLat,
      "endLng": endLng,
      "isSynced": isSynced,
      "status": status,
      "route": route.map((e) => {"lat": e.lat, "lng": e.lng}).toList(),
    };
  }

  // ==============================
  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      // FIX: fallback to a new UUID instead of empty string
      id: json["_id"]?.toString() ??
          json["id"]?.toString() ??
          const Uuid().v4(),

      startTime: json["startTime"] != null
          ? DateTime.parse(json["startTime"])
          : DateTime.now(),

      endTime: json["endTime"] != null
          ? DateTime.parse(json["endTime"])
          : null,

      distance: (json["distance"] ?? 0).toDouble(),
      avgSpeed: (json["avgSpeed"] ?? 0).toDouble(),

      startLat: (json["startLat"] ?? 0).toDouble(),
      startLng: (json["startLng"] ?? 0).toDouble(),
      endLat: (json["endLat"] ?? 0).toDouble(),
      endLng: (json["endLng"] ?? 0).toDouble(),

      isValid: json['isValid'],
      invalidReason: json['invalidReason'],

      route: json["route"] != null
          ? (json["route"] as List)
          .map((e) => LatLngPoint(
        lat: (e["lat"] ?? 0).toDouble(),
        lng: (e["lng"] ?? 0).toDouble(),

      )
      )

          .toList()
          : [],


      isSynced: json["isSynced"] ?? false,
      status: json["status"] ?? "active",
    );
  }
}