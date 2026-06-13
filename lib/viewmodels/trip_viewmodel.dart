import 'package:flutter/material.dart';

import '../model/trip_model.dart';
import '../service/storage_service.dart';


class TripViewModel extends ChangeNotifier {
  //final StorageService _storageService = StorageService();
  List<Trip> trips = [];
  Future<void> loadTrips() async {
   // trips = await _storageService.getTrips(); // stays same
    notifyListeners();
  }

  Trip? getTripById(String id) {
    try {
      return trips.firstWhere((trip) => trip.id == id);
    } catch (e) {
      return null;
    }
  }

}