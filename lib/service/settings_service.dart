import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const _onboardingKey = 'onboarding_complete';
  static const _useMilesKey = 'use_miles';
  static const _themeKey = 'theme_mode';
  // Replace these with your real hosted URLs before Play Store submission.
  static const privacyPolicyUrl = 'https://trackflow.app/privacy-policy';
  static const termsOfServiceUrl = 'https://trackflow.app/terms-of-service';
  static const _locationDisclosureKey = 'location_disclosure_shown';

  Future<bool> isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }

  Future<void> setOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
  }

  Future<bool> getUseMiles() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_useMilesKey) ?? false;
  }

  Future<void> setUseMiles(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_useMilesKey, value);
  }

  Future<String> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_themeKey) ?? 'system';
  }

  Future<void> setThemeMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode);
  }

  Future<bool> hasShownLocationDisclosure() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_locationDisclosureKey) ?? false;
  }

  Future<void> setLocationDisclosureShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_locationDisclosureKey, true);
  }
}
