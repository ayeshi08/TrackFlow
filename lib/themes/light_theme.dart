import 'package:flutter/material.dart';

class LightTheme {
  static ThemeData theme = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Inter', // 🌟 ADD THIS LINE HERE

    scaffoldBackgroundColor: Colors.white,

    colorScheme: const ColorScheme.light(
      primary: Color(0xFF3B82F6),
      secondary: Color(0xFF2563EB),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    ),

    cardTheme: CardThemeData(
      color: const Color(0xFFF8FAFC),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );
}