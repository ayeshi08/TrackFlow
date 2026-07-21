import 'package:flutter/material.dart';
import '../service/settings_service.dart';

class SettingsViewModel extends ChangeNotifier {
  final SettingsService _service = SettingsService();
  ThemeMode themeMode = ThemeMode.system;
  bool useMiles = false;
  bool isLoaded = false;

  SettingsViewModel() {
    load();
  }

  // Future<void> load() async {
  //   useMiles = await _service.getUseMiles();
  //   isLoaded = true;
  //   notifyListeners();
  // }
  Future<void> load() async {
    useMiles = await _service.getUseMiles();

    final theme = await _service.getThemeMode();

    switch (theme) {
      case 'light':
        themeMode = ThemeMode.light;
        break;

      case 'dark':
        themeMode = ThemeMode.dark;
        break;

      default:
        themeMode = ThemeMode.system;
    }

    isLoaded = true;
    notifyListeners();
  }

  Future<void> setUseMiles(bool value) async {
    useMiles = value;
    await _service.setUseMiles(value);
    notifyListeners();
  }

  String formatDistance(double km) {
    if (useMiles) {
      return '${(km * 0.621371).toStringAsFixed(2)} mi';
    }
    return '${km.toStringAsFixed(2)} km';
  }

  String formatSpeed(double kmh) {
    if (useMiles) {
      return '${(kmh * 0.621371).toStringAsFixed(1)} mph';
    }
    return '${kmh.toStringAsFixed(1)} km/h';
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode = mode;

    String value = 'system';

    if (mode == ThemeMode.light) {
      value = 'light';
    } else if (mode == ThemeMode.dark) {
      value = 'dark';
    }

    await _service.setThemeMode(value);

    notifyListeners();
  }

  double co2SavedKg(double km) => km * 0.12;
}
