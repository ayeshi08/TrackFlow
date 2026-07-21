// import 'package:flutter/material.dart';
//
// class LoginViewModel extends ChangeNotifier {
//   String email = "";
//   String password = "";
//   bool isLoading = false;
//
//   void setEmail(String value) {
//     email = value;
//     notifyListeners();
//   }
//
//   void setPassword(String value) {
//     password = value;
//     notifyListeners();
//   }
//
//   Future<bool> login() async {
//     isLoading = true;
//     notifyListeners();
//
//     await Future.delayed(const Duration(seconds: 2)); // simulate network
//
//     isLoading = false;
//     notifyListeners();
//
//     // For demo purpose, any email/password combination is "valid"
//     return email.isNotEmpty && password.isNotEmpty;
//   }
// }
