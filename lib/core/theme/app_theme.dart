import 'package:flutter/material.dart';

class AppTheme {
  static const Color seedColor = Color(0xFF6750A4);
  static const String primaryFontFamily = 'Poppins';

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: seedColor,
    brightness: Brightness.light,
    fontFamily: primaryFontFamily,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: seedColor,
    brightness: Brightness.dark,
    fontFamily: primaryFontFamily,
  );
}