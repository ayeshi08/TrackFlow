// import 'dart:convert';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:http/http.dart' as http;
// import '../model/user_model.dart';
//
// class AuthService {
//   // final String baseUrl = AppConfig.baseUrl;
//   final String baseUrl =
//       "https://trip-backend-production-a330.up.railway.app/auth";
//
//   // This encrypts JWT token using Android Keystore — production level security
//   static const _storage = FlutterSecureStorage(
//     aOptions: AndroidOptions(encryptedSharedPreferences: true),
//   );
//
//   static const _tokenKey = 'auth_token';
//   static const _userKey = 'auth_user';
//   static const _guestKey = 'is_guest';
//
//   // ==============================
//   // Register — email only
//   Future<Map<String, dynamic>> register({
//     required String name,
//     String? email,
//     String? phone,
//     required String password,
//   }) async {
//     try {
//       final Map<String, dynamic> body = {"name": name, "password": password};
//       if (email != null && email.isNotEmpty) body["email"] = email;
//       if (phone != null && phone.isNotEmpty) body["phone"] = phone;
//
//       final response = await http
//           .post(
//             Uri.parse("$baseUrl/register"),
//             headers: {"Content-Type": "application/json"},
//             body: jsonEncode(body),
//           )
//           .timeout(const Duration(seconds: 15));
//
//       final data = jsonDecode(response.body);
//       if (response.statusCode == 201 && data['success'] == true) {
//         return {
//           'success': true,
//           'userId': data['userId']?.toString() ?? '',
//           'requiresVerification': data['requiresVerification'] ?? false,
//           'message': data['message'] ?? '',
//         };
//       } else {
//         return {
//           'success': false,
//           'message': data['message'] ?? 'Registration failed',
//         };
//       }
//     } catch (e) {
//       return {
//         'success': false,
//         'message': 'Cannot connect to server. Check your internet.',
//       };
//     }
//   }
//
//   // ==============================
//   // Verify OTP
//   Future<Map<String, dynamic>> verifyOtp({
//     required String userId,
//     required String otp,
//   }) async {
//     try {
//       final response = await http
//           .post(
//             Uri.parse("$baseUrl/verify-otp"),
//             headers: {"Content-Type": "application/json"},
//             body: jsonEncode({"userId": userId, "otp": otp}),
//           )
//           .timeout(const Duration(seconds: 10));
//
//       final data = jsonDecode(response.body);
//       if (response.statusCode == 200 && data['success'] == true) {
//         await _saveSession(data['token'], data['user']);
//         return {'success': true};
//       } else {
//         return {
//           'success': false,
//           'message': data['message'] ?? 'Verification failed',
//         };
//       }
//     } catch (e) {
//       return {'success': false, 'message': 'Cannot connect to server.'};
//     }
//   }
//
//   // ==============================
//   // Resend OTP
//   Future<Map<String, dynamic>> resendOtp({required String userId}) async {
//     try {
//       final response = await http
//           .post(
//             Uri.parse("$baseUrl/resend-otp"),
//             headers: {"Content-Type": "application/json"},
//             body: jsonEncode({"userId": userId}),
//           )
//           .timeout(const Duration(seconds: 10));
//
//       final data = jsonDecode(response.body);
//       return {'success': data['success'], 'message': data['message']};
//     } catch (e) {
//       return {'success': false, 'message': 'Cannot connect to server.'};
//     }
//   }
//
//   // ==============================
//   // Login
//   Future<Map<String, dynamic>> login({
//     required String emailOrPhone,
//     required String password,
//   }) async {
//     try {
//       final response = await http
//           .post(
//             Uri.parse("$baseUrl/login"),
//             headers: {"Content-Type": "application/json"},
//             body: jsonEncode({
//               "emailOrPhone": emailOrPhone,
//               "password": password,
//             }),
//           )
//           .timeout(const Duration(seconds: 15));
//
//       final data = jsonDecode(response.body);
//       if (response.statusCode == 200 && data['success'] == true) {
//         await _saveSession(data['token'], data['user']);
//         return {'success': true};
//       } else if (data['requiresVerification'] == true) {
//         return {
//           'success': false,
//           'requiresVerification': true,
//           'userId': data['userId'].toString(),
//           'message': data['message'],
//         };
//       } else {
//         return {'success': false, 'message': data['message'] ?? 'Login failed'};
//       }
//     } catch (e) {
//       return {
//         'success': false,
//         'message': 'Cannot connect to server. Check your internet.',
//       };
//     }
//   }
//
//   // ==============================
//   // Forgot password
//   Future<Map<String, dynamic>> forgotPassword({
//     required String emailOrPhone,
//     bool usePhone = false,
//   }) async {
//     try {
//       final body = usePhone ? {"phone": emailOrPhone} : {"email": emailOrPhone};
//       final response = await http
//           .post(
//             Uri.parse("$baseUrl/forgot-password"),
//             headers: {"Content-Type": "application/json"},
//             body: jsonEncode(body),
//           )
//           .timeout(const Duration(seconds: 10));
//
//       final data = jsonDecode(response.body);
//       return {
//         'success': data['success'],
//         'message': data['message'],
//         'userId': data['userId']?.toString(),
//       };
//     } catch (e) {
//       return {'success': false, 'message': 'Cannot connect to server.'};
//     }
//   }
//
//   // ==============================
//   // Reset password
//   Future<Map<String, dynamic>> resetPassword({
//     required String userId,
//     required String otp,
//     required String newPassword,
//   }) async {
//     try {
//       final response = await http
//           .post(
//             Uri.parse("$baseUrl/reset-password"),
//             headers: {"Content-Type": "application/json"},
//             body: jsonEncode({
//               "userId": userId,
//               "otp": otp,
//               "newPassword": newPassword,
//             }),
//           )
//           .timeout(const Duration(seconds: 10));
//
//       final data = jsonDecode(response.body);
//       return {'success': data['success'], 'message': data['message']};
//     } catch (e) {
//       return {'success': false, 'message': 'Cannot connect to server.'};
//     }
//   }
//
//   // ==============================
//   // Update profile name
//   Future<Map<String, dynamic>> updateProfile({required String name}) async {
//     try {
//       final token = await getToken();
//       final response = await http
//           .put(
//             Uri.parse("$baseUrl/profile"),
//             headers: {
//               "Content-Type": "application/json",
//               "Authorization": "Bearer $token",
//             },
//             body: jsonEncode({"name": name}),
//           )
//           .timeout(const Duration(seconds: 10));
//
//       final data = jsonDecode(response.body);
//       if (data['success'] == true) {
//         await _storage.write(key: _userKey, value: jsonEncode(data['user']));
//         return {'success': true};
//       }
//       return {'success': false, 'message': data['message']};
//     } catch (e) {
//       return {'success': false, 'message': 'Cannot connect to server.'};
//     }
//   }
//
//   // ==============================
//   // Change password
//   Future<Map<String, dynamic>> changePassword({
//     required String currentPassword,
//     required String newPassword,
//   }) async {
//     try {
//       final token = await getToken();
//       final response = await http
//           .put(
//             Uri.parse("$baseUrl/change-password"),
//             headers: {
//               "Content-Type": "application/json",
//               "Authorization": "Bearer $token",
//             },
//             body: jsonEncode({
//               "currentPassword": currentPassword,
//               "newPassword": newPassword,
//             }),
//           )
//           .timeout(const Duration(seconds: 10));
//
//       final data = jsonDecode(response.body);
//       return {'success': data['success'], 'message': data['message']};
//     } catch (e) {
//       return {'success': false, 'message': 'Cannot connect to server.'};
//     }
//   }
//
//   // ==============================
//   // Guest login
//   Future<void> loginAsGuest() async {
//     await _storage.write(key: _guestKey, value: 'true');
//   }
//
//   // ==============================
//   // Delete account
//   Future<Map<String, dynamic>> deleteAccount() async {
//     try {
//       final token = await getToken();
//       if (token == null || token.isEmpty) {
//         return {'success': false, 'message': 'Not logged in'};
//       }
//
//       final response = await http
//           .delete(
//             Uri.parse("$baseUrl/delete-account"),
//             headers: {
//               "Content-Type": "application/json",
//               "Authorization": "Bearer $token",
//             },
//           )
//           .timeout(const Duration(seconds: 15));
//
//       final data = jsonDecode(response.body);
//       if (response.statusCode == 200 && data['success'] == true) {
//         await logout();
//         return {
//           'success': true,
//           'message': data['message'] ?? 'Account deleted',
//         };
//       }
//       return {
//         'success': false,
//         'message': data['message'] ?? 'Failed to delete account',
//       };
//     } catch (e) {
//       // If backend endpoint is not ready yet, still clear local session
//       await logout();
//       return {
//         'success': true,
//         'message':
//             'Local session cleared. Contact support if server account still exists.',
//       };
//     }
//   }
//
//   Future<bool> isGuest() async {
//     final val = await _storage.read(key: _guestKey);
//     return val == 'true';
//   }
//
//   // Logout — clears all secure storage
//   Future<void> logout() async {
//     await _storage.deleteAll();
//   }
//
//   Future<String?> getToken() async {
//     return await _storage.read(key: _tokenKey);
//   }
//
//   Future<User?> getUser() async {
//     final userJson = await _storage.read(key: _userKey);
//     if (userJson == null) return null;
//     return User.fromJson(jsonDecode(userJson));
//   }
//
//   Future<bool> isLoggedIn() async {
//     final token = await getToken();
//     final guest = await isGuest();
//     return (token != null && token.isNotEmpty) || guest;
//   }
//
//   Future<void> _saveSession(String token, Map<String, dynamic> userJson) async {
//     await _storage.write(key: _tokenKey, value: token);
//     await _storage.write(key: _userKey, value: jsonEncode(userJson));
//     await _storage.delete(key: _guestKey);
//   }
// }

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../model/user_model.dart';

class AuthService {
  // final String baseUrl = AppConfig.baseUrl;
  final String baseUrl =
      "https://trip-backend-production-a330.up.railway.app/auth";

  // This encrypts JWT token using Android Keystore — production level security
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const _tokenKey = 'auth_token';
  static const _userKey = 'auth_user';
  static const _guestKey = 'is_guest';

  // ==============================
  // Register — email only
  Future<Map<String, dynamic>> register({
    required String name,
    String? email,
   // String? phone,
    required String password,
  }) async {
    try {
      final Map<String, dynamic> body = {"name": name, "password": password};
      if (email != null && email.isNotEmpty) body["email"] = email;
    //  if (phone != null && phone.isNotEmpty) body["phone"] = phone;

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
        return {
          'success': false,
          'message': data['message'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Cannot connect to server. Check your internet.',
      };
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
        return {
          'success': false,
          'message': data['message'] ?? 'Verification failed',
        };
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
        body: jsonEncode({
          "email": emailOrPhone,
          "password": password,
        }),
      )
          .timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body);

      // Handle 403 status code configuration for unverified registration status
      if (response.statusCode == 200 && data['success'] == true) {
        await _saveSession(data['token'], data['user']);
        return {'success': true};
      } else if (data['requiresVerification'] == true || response.statusCode == 403) {
        return {
          'success': false,
          'requiresVerification': true,
          'userId': data['userId']?.toString() ?? '',
          'message': data['message'] ?? 'Verification required.',
        };
      } else {
        return {'success': false, 'message': data['message'] ?? 'Login failed'};
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Cannot connect to server. Check your internet.',
      };
    }
  }

  // ==============================
  // Forgot password
  Future<Map<String, dynamic>> forgotPassword({
    required String emailOrPhone,
    bool usePhone = false,
  }) async {
    try {
      final body = usePhone ? {"phone": emailOrPhone} : {"email": emailOrPhone};
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
      return {'success': false, 'message': 'Cannot connect to server.'};
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
        await _storage.write(key: _userKey, value: jsonEncode(data['user']));
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
    await _storage.write(key: _guestKey, value: 'true');
  }

  // ==============================
  // Delete account
  Future<Map<String, dynamic>> deleteAccount() async {
    try {
      final token = await getToken();
      if (token == null || token.isEmpty) {
        return {'success': false, 'message': 'Not logged in'};
      }

      final response = await http
          .delete(
        Uri.parse("$baseUrl/delete-account"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      )
          .timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        await logout();
        return {
          'success': true,
          'message': data['message'] ?? 'Account deleted',
        };
      }
      return {
        'success': false,
        'message': data['message'] ?? 'Failed to delete account',
      };
    } catch (e) {
      await logout();
      return {
        'success': true,
        'message':
        'Local session cleared. Contact support if server account still exists.',
      };
    }
  }

  Future<bool> isGuest() async {
    final val = await _storage.read(key: _guestKey);
    return val == 'true';
  }

  // Logout — clears all secure storage
  Future<void> logout() async {
    await _storage.deleteAll();
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<User?> getUser() async {
    final userJson = await _storage.read(key: _userKey);
    if (userJson == null) return null;
    return User.fromJson(jsonDecode(userJson));
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    final guest = await isGuest();
    return (token != null && token.isNotEmpty) || guest;
  }

  Future<void> _saveSession(String token, Map<String, dynamic> userJson) async {
    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(key: _userKey, value: jsonEncode(userJson));
    await _storage.delete(key: _guestKey);
  }
}