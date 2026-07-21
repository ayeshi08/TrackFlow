import 'package:flutter/material.dart';

class DarkTheme {
  static ThemeData theme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Inter', // 🌟 ADD THIS LINE HERE

    scaffoldBackgroundColor: const Color(0xFF0A0A0A),

    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF3B82F6),
      secondary: Color(0xFF2563EB),
      surface: Color(0xFF1A1A1A),
      onSurface: Colors.white,
    ),

    cardColor: const Color(0xFF1A1A1A),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF111827),
      elevation: 0,
    ),

    cardTheme: CardThemeData(
      color: const Color(0xFF1A1A1A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );
}