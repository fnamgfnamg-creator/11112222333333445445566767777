import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color primaryBlack = Color(0xFF000000);
  static const Color darkGray = Color(0xFF1A1A1A);
  static const Color mediumGray = Color(0xFF2D2D2D);
  static const Color lightGray = Color(0xFF404040);
  static const Color gold = Color(0xFFFFD700);
  static const Color darkGold = Color(0xFFB8860B);
  static const Color white = Color(0xFFFFFFFF);
  static const Color red = Color(0xFFFF4444);
  static const Color green = Color(0xFF00C851);

  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: gold,
      scaffoldBackgroundColor: primaryBlack,
      brightness: Brightness.dark,
      fontFamily: 'Poppins',
      
      colorScheme: const ColorScheme.dark(
        primary: gold,
        secondary: darkGold,
        surface: darkGray,
        background: primaryBlack,
        error: red,
      ),
      
      appBarTheme: const AppBarTheme(
        backgroundColor: darkGray,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: gold),
        titleTextStyle: TextStyle(
          color: gold,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: gold,
          foregroundColor: primaryBlack,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: gold,
          side: const BorderSide(color: gold, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: mediumGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: gold, width: 2),
        ),
        labelStyle: const TextStyle(color: white),
        hintStyle: TextStyle(color: white.withOpacity(0.5)),
        prefixIconColor: gold,
      ),
      
      cardTheme: CardTheme(
        color: darkGray,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: gold,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: white,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: white,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: white,
        ),
      ),
    );
  }
}
