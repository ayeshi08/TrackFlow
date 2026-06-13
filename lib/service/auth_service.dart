import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_model.dart';

class AuthService {
  final String baseUrl = "https://trip-backend-production-a330.up.railway.app/auth";

  static const _tokenKey = 'auth_token';
  static const _userKey = 'auth_user';
  static const _guestKey = 'is_guest';

  // ==============================
  // Register — returns userId for OTP verification
  Future<Map<String, dynamic>> register({
    required String name,
    String? email,
    String? phone,
    required String password,
  }) async {
    try {
      final Map<String, dynamic> body = {
        "name": name,
        "password": password,
      };
      if (email != null && email.isNotEmpty) body["email"] = email;
      if (phone != null && phone.isNotEmpty) body["phone"] = phone;

      final response = await http
          .post(
        Uri.parse("$baseUrl/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      )
          .timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 && data['success'] == true) {
        return {
          'success': true,
          'userId': data['userId']?.toString() ?? '',
          'requiresVerification': data['requiresVerification'] ?? false,
          'message': data['message'] ?? '',
        };
      } else {
        return {'success': false, 'message': data['message'] ?? 'Registration failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Cannot connect to server. Check your internet.'};
    }
  }

  // ==============================
  // Verify OTP
  Future<Map<String, dynamic>> verifyOtp({
    required String userId,
    required String otp,
  }) async {
    try {
      final response = await http
          .post(
        Uri.parse("$baseUrl/verify-otp"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"userId": userId, "otp": otp}),
      )
          .timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        await _saveSession(data['token'], data['user']);
        return {'success': true};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Verification failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Cannot connect to server.'};
    }
  }

  // ==============================
  // Resend OTP
  Future<Map<String, dynamic>> resendOtp({required String userId}) async {
    try {
      final response = await http
          .post(
        Uri.parse("$baseUrl/resend-otp"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"userId": userId}),
      )
          .timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);
      return {'success': data['success'], 'message': data['message']};
    } catch (e) {
      return {'success': false, 'message': 'Cannot connect to server.'};
    }
  }

  // ==============================
  // Login
  Future<Map<String, dynamic>> login({
    required String emailOrPhone,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
        Uri.parse("$baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"emailOrPhone": emailOrPhone, "password": password}),
      )
          .timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        await _saveSession(data['token'], data['user']);
        return {'success': true};
      } else if (data['requiresVerification'] == true) {
        return {
          'success': false,
          'requiresVerification': true,
          'userId': data['userId'].toString(),
          'message': data['message'],
        };
      } else {
        return {'success': false, 'message': data['message'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Cannot connect to server. Check your internet.'};
    }
  }

  // ==============================
  // Forgot password
  Future<Map<String, dynamic>> forgotPassword({
    required String emailOrPhone,
    bool usePhone = false,
  }) async {
    try {
      final body = usePhone
          ? {"phone": emailOrPhone}
          : {"email": emailOrPhone};

      final response = await http
          .post(
        Uri.parse("$baseUrl/forgot-password"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      )
          .timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);
      return {
        'success': data['success'],
        'message': data['message'],
        'userId': data['userId']?.toString(),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Cannot connect to server. Check your internet.'
      };
    }
  }

  // ==============================
  // Reset password
  Future<Map<String, dynamic>> resetPassword({
    required String userId,
    required String otp,
    required String newPassword,
  }) async {
    try {
      final response = await http
          .post(
        Uri.parse("$baseUrl/reset-password"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "userId": userId,
          "otp": otp,
          "newPassword": newPassword,
        }),
      )
          .timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);
      return {'success': data['success'], 'message': data['message']};
    } catch (e) {
      return {'success': false, 'message': 'Cannot connect to server.'};
    }
  }

  // ==============================
  // Update profile name
  Future<Map<String, dynamic>> updateProfile({required String name}) async {
    try {
      final token = await getToken();
      final response = await http
          .put(
        Uri.parse("$baseUrl/profile"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"name": name}),
      )
          .timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_userKey, jsonEncode(data['user']));
        return {'success': true};
      }
      return {'success': false, 'message': data['message']};
    } catch (e) {
      return {'success': false, 'message': 'Cannot connect to server.'};
    }
  }

  // ==============================
  // Change password
  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final token = await getToken();
      final response = await http
          .put(
        Uri.parse("$baseUrl/change-password"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "currentPassword": currentPassword,
          "newPassword": newPassword,
        }),
      )
          .timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);
      return {'success': data['success'], 'message': data['message']};
    } catch (e) {
      return {'success': false, 'message': 'Cannot connect to server.'};
    }
  }

  // ==============================
  // Guest login
  Future<void> loginAsGuest() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_guestKey, true);
  }

  Future<bool> isGuest() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_guestKey) ?? false;
  }

  // ==============================
  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
    await prefs.remove(_guestKey);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson == null) return null;
    return User.fromJson(jsonDecode(userJson));
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    final guest = await isGuest();
    return (token != null && token.isNotEmpty) || guest;
  }

  Future<void> _saveSession(String token, Map<String, dynamic> userJson) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userKey, jsonEncode(userJson));
    await prefs.remove(_guestKey);
  }
}