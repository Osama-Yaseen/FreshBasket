import 'package:flutter/material.dart';

class AppThemes {
  /// ✅ Light Theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light, // ✅ Ensure it matches colorScheme
    colorScheme: const ColorScheme.light(
      brightness: Brightness.light, // ✅ MUST MATCH THEME BRIGHTNESS
      primary: Colors.green,
      secondary: Colors.orange,
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
    ),
  );

  /// ✅ Dark Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark, // ✅ Ensure it matches colorScheme
    colorScheme: const ColorScheme.dark(
      brightness: Brightness.dark, // ✅ MUST MATCH THEME BRIGHTNESS
      primary: Colors.green,
      secondary: Colors.orange,
    ),
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    ),
  );
}
