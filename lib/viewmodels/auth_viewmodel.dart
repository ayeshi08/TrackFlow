import 'package:flutter/material.dart';

import '../model/user_model.dart';
import '../service/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? currentUser;
  bool isLoading = false;
  bool isGuest = false;
  String? errorMessage;

  Future<bool> checkLoginStatus() async {
    final guest = await _authService.isGuest();
    if (guest) {
      isGuest = true;
      notifyListeners();
      return true;
    }
    final loggedIn = await _authService.isLoggedIn();
    if (loggedIn) {
      currentUser = await _authService.getUser();
      notifyListeners();
    }
    return loggedIn;
  }

  // Returns userId on success for OTP screen
  Future<Map<String, dynamic>> register({
    required String name,
    String? email,
    String? phone,
    required String password,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _authService.register(
      name: name,
      email: email,
      //phone: phone,
      password: password,
    );

    isLoading = false;
    if (!(result['success'] as bool))
      errorMessage = result['message'] as String?;
    notifyListeners();
    return result;
  }

  Future<bool> verifyOtp({required String userId, required String otp}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _authService.verifyOtp(userId: userId, otp: otp);

    isLoading = false;

    if (result['success'] == true) {
      currentUser = await _authService.getUser();
      isGuest = false;
      notifyListeners();
      return true;
    } else {
      errorMessage = result['message'] as String?;
      notifyListeners();
      return false;
    }
  }

  Future<void> resendOtp({required String userId}) async {
    await _authService.resendOtp(userId: userId);
  }

  Future<Map<String, dynamic>> login({
    required String emailOrPhone,
    required String password,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _authService.login(
      emailOrPhone: emailOrPhone,
      password: password,
    );

    isLoading = false;

    if (result['success'] == true) {
      currentUser = await _authService.getUser();
      isGuest = false;
      notifyListeners();
    } else {
      errorMessage = result['message'] as String?;
      notifyListeners();
    }

    return result;
  }

  Future<Map<String, dynamic>> forgotPassword({
    required String emailOrPhone,
    bool usePhone = false,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _authService.forgotPassword(
      emailOrPhone: emailOrPhone,
      usePhone: usePhone,
    );

    isLoading = false;
    notifyListeners();
    return result;
  }

  Future<bool> resetPassword({
    required String userId,
    required String otp,
    required String newPassword,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _authService.resetPassword(
      userId: userId,
      otp: otp,
      newPassword: newPassword,
    );

    isLoading = false;

    if (result['success'] == true) {
      notifyListeners();
      return true;
    } else {
      errorMessage = result['message'] as String?;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProfile({required String name}) async {
    isLoading = true;
    notifyListeners();

    final result = await _authService.updateProfile(name: name);

    isLoading = false;
    if (result['success'] == true) {
      currentUser = await _authService.getUser();
      notifyListeners();
      return true;
    } else {
      errorMessage = result['message'] as String?;
      notifyListeners();
      return false;
    }
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _authService.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    isLoading = false;

    if (result['success'] == true) {
      notifyListeners();
      return true;
    } else {
      errorMessage = result['message'] as String?;
      notifyListeners();
      return false;
    }
  }

  Future<void> loginAsGuest() async {
    await _authService.loginAsGuest();
    isGuest = true;
    currentUser = null;
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.logout();
    currentUser = null;
    isGuest = false;
    notifyListeners();
  }

  Future<Map<String, dynamic>> deleteAccount() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _authService.deleteAccount();

    isLoading = false;
    if (result['success'] == true) {
      currentUser = null;
      isGuest = false;
    } else {
      errorMessage = result['message'] as String?;
    }
    notifyListeners();
    return result;
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}
