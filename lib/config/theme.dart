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
  );
}
