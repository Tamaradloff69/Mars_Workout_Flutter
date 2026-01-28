import 'package:flutter/material.dart';

class AppTheme {
  // Base Colors
  static const Color primaryColor = Color(0xFFFF5800);
  static const Color primaryContainer = Color(0xFFFF9C6A);
  static const Color secondaryColor = Color(0xFFF5F5F5);
  static const Color cardBackground = Colors.white;
  static const Color textDark = Color(0xFF212121);
  static const Color textLight = Color(0xFF757575);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color successContainer = Color(0xFFABFFB1);
  static const Color warningColor = Color(0xFFFFC107); // Amber

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: secondaryColor,

      colorScheme: const ColorScheme.light(primary: primaryColor, primaryContainer: primaryContainer, secondary: primaryColor, tertiary: successColor, tertiaryContainer: successContainer, surface: cardBackground, onSurface: textDark, error: Colors.redAccent),

      // Global AppBar Style
      appBarTheme: const AppBarTheme(
        backgroundColor: cardBackground,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: textDark),
        titleTextStyle: TextStyle(color: textDark, fontSize: 18, fontWeight: FontWeight.bold),
      ),

      // Global Card Style
      cardTheme: CardThemeData(
        color: cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        margin: EdgeInsets.zero,
      ),

      // Text Styles
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textDark),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textDark),
        bodyLarge: TextStyle(fontSize: 14, color: textDark, height: 1.5),
        bodyMedium: TextStyle(fontSize: 13, color: textLight, height: 1.4),
        headlineMedium: TextStyle(
          // Timer Text
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
        displayLarge: TextStyle(
          // Big Timer Numbers
          fontSize: 60,
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
      ),

      // Button Styles
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: primaryColor, foregroundColor: Colors.white),
    );
  }
}
