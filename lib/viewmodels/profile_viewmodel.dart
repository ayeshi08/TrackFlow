import 'package:flutter/material.dart';

class ProfileViewModel extends ChangeNotifier {
  String name = "Alexander Wright";
  String role = "Senior Logistics Partner";
  String id = "V-982341";
  int trips = 42;
  double score = 4.9;
  String miles = "1.2k";

  void updateProfile({
    String? newName,
    String? newRole,
    int? newTrips,
    double? newScore,
    String? newMiles,
  }) {
    if (newName != null) name = newName;
    if (newRole != null) role = newRole;
    if (newTrips != null) trips = newTrips;
    if (newScore != null) score = newScore;
    if (newMiles != null) miles = newMiles;
    notifyListeners();
  }
}
