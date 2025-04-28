// lib/config/text_styles.dart
import 'package:flutter/material.dart';

class AppTextStyles {
  static const Color textColor = Color(0xFF333333);

  // Thin (100)
  static TextStyle thin({double size = 14.0, Color color = textColor}) {
    return TextStyle(fontSize: size, fontFamily: 'One', color: color);
  }

  // ExtraLight (200)
  static TextStyle extraLight({double size = 14.0, Color color = textColor}) {
    return TextStyle(fontSize: size, fontFamily: 'Two', color: color);
  }

  // Light (300)
  static TextStyle light({double size = 14.0, Color color = textColor}) {
    return TextStyle(fontSize: size, fontFamily: 'Three', color: color);
  }

  // Regular (400)
  static TextStyle regular({double size = 14.0, Color color = textColor}) {
    return TextStyle(fontSize: size, fontFamily: 'Four', color: color);
  }

  // Medium (500)
  static TextStyle medium({double size = 14.0, Color color = textColor}) {
    return TextStyle(fontSize: size, fontFamily: 'Five', color: color);
  }

  // SemiBold (600)
  static TextStyle semiBold({double size = 14.0, Color color = textColor}) {
    return TextStyle(fontSize: size, fontFamily: 'Six', color: color);
  }

  // Bold (700)
  static TextStyle bold({double size = 14.0, Color color = textColor}) {
    return TextStyle(fontSize: size, fontFamily: 'Seven', color: color);
  }

  // ExtraBold (800)
  static TextStyle extraBold({double size = 14.0, Color color = textColor}) {
    return TextStyle(fontSize: size, fontFamily: 'Eight', color: color);
  }

  // Black (900)
  static TextStyle black({double size = 14.0, Color color = textColor}) {
    return TextStyle(fontSize: size, fontFamily: 'Nine', color: color);
  }

  // Common text styles for your app
  static TextStyle headline1 = black(size: 28.0);
  static TextStyle headline2 = extraBold(size: 24.0);
  static TextStyle headline3 = bold(size: 22.0);
  static TextStyle headline4 = semiBold(size: 20.0);
  static TextStyle headline5 = medium(size: 18.0);
  static TextStyle headline6 = regular(size: 16.0);

  static TextStyle subtitle1 = semiBold(size: 16.0);
  static TextStyle subtitle2 = medium(size: 14.0);

  static TextStyle bodyText1 = regular(size: 16.0);
  static TextStyle bodyText2 = regular(size: 14.0);

  static TextStyle caption = light(size: 12.0, color: const Color(0xFF757575));
  static TextStyle button = semiBold(size: 16.0, color: Colors.white);
}
