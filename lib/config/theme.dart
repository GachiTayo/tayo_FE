// lib/config/theme.dart
import 'package:flutter/material.dart';
import 'text_styles.dart';

class AppTheme {
  // Define your color scheme
  static const Color primaryColor = Color(0xFFA6FE70);
  static const Color accentColor = Color(0xFF131D0C);
  static const Color textColor = Color(0xFF333333);
  static const Color lightGrey = Color(0xFFEEEEEE);

  // Light theme
  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      secondary: accentColor,
    ),
    scaffoldBackgroundColor: Colors.white,

    // App Bar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: AppTextStyles.semiBold(size: 20.0, color: Colors.white),
    ),

    // Define your text theme
    textTheme: TextTheme(
      // Display styles
      displayLarge: AppTextStyles.bold(size: 32.0),
      displayMedium: AppTextStyles.bold(size: 28.0),
      displaySmall: AppTextStyles.semiBold(size: 24.0),

      // Headline styles
      headlineLarge: AppTextStyles.bold(size: 22.0),
      headlineMedium: AppTextStyles.semiBold(size: 20.0),
      headlineSmall: AppTextStyles.semiBold(size: 18.0),

      // Title styles
      titleLarge: AppTextStyles.semiBold(size: 18.0),
      titleMedium: AppTextStyles.medium(size: 16.0),
      titleSmall: AppTextStyles.medium(size: 14.0),

      // Body styles
      bodyLarge: AppTextStyles.regular(size: 16.0),
      bodyMedium: AppTextStyles.regular(size: 14.0),
      bodySmall: AppTextStyles.regular(size: 12.0),

      // Label styles
      labelLarge: AppTextStyles.medium(size: 14.0),
      labelMedium: AppTextStyles.medium(size: 12.0),
      labelSmall: AppTextStyles.medium(size: 11.0),
    ),

    // Button themes
    buttonTheme: const ButtonThemeData(
      buttonColor: primaryColor,
      textTheme: ButtonTextTheme.primary,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(120, 45),
        textStyle: AppTextStyles.semiBold(size: 16.0, color: Colors.white),
      ),
    ),

    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      labelStyle: AppTextStyles.regular(size: 14.0),
      hintStyle: AppTextStyles.regular(
        size: 14.0,
        color: const Color(0xFF999999),
      ),
    ),
  );
}
