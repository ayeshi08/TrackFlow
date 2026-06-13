// import 'package:flutter/material.dart';
//
// import '../service/auth_service.dart';
//
// class LoginViewModel extends ChangeNotifier {
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//
//   final AuthService _authService = AuthService();
//
//   bool isLoading = false;
//   String? errorMessage;
//
//   Future<void> login(Function onSuccess) async {
//     isLoading = true;
//     errorMessage = null;
//     notifyListeners();
//
//     final success = await _authService.login(
//         emailController.text, passwordController.text);
//
//     if (success) {
//       onSuccess();
//     } else {
//       errorMessage = "Invalid credentials";
//     }
//
//     isLoading = false;
//     notifyListeners();
//   }
// }
import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  String email = "";
  String password = "";
  bool isLoading = false;

  void setEmail(String value) {
    email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    password = value;
    notifyListeners();
  }

  Future<bool> login() async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2)); // simulate network

    isLoading = false;
    notifyListeners();

    // For demo purpose, any email/password combination is "valid"
    return email.isNotEmpty && password.isNotEmpty;
  }
}
