import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityViewModel extends ChangeNotifier {
  bool isOnline = true;

  // ADD THIS
  bool justReconnected = false;

  StreamSubscription? _subscription;

  ConnectivityViewModel() {
    initialize();
  }

  Future<void> initialize() async {
    final result = await Connectivity().checkConnectivity();

    isOnline = !result.contains(ConnectivityResult.none);

    notifyListeners();

    _subscription = Connectivity().onConnectivityChanged.listen((results) {
      final wasOffline = !isOnline;

      isOnline = !results.contains(ConnectivityResult.none);

      // User was offline and now internet returned
      if (wasOffline && isOnline) {
        justReconnected = true;

        notifyListeners();

        Future.delayed(const Duration(seconds: 3), () {
          justReconnected = false;
          notifyListeners();
        });

        return;
      }

      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
