import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    colorScheme: const ColorScheme.light(
      primary: Color(0xff1e1e2f),
      primaryContainer: Color(0xff1e1e2f),
      secondary: Color(0xff5e5e5e),
      surface: Color(0xfff8faff),
      onError: Color(0xff950F0F),
    ),
    useMaterial3: true,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(fontFamily: 'Roboto'),
      bodyLarge: TextStyle(fontFamily: 'Roboto'),
      displayLarge: TextStyle(fontFamily: 'Roboto'),
      displayMedium: TextStyle(fontFamily: 'Roboto'),
      displaySmall: TextStyle(fontFamily: 'Roboto'),
      headlineMedium: TextStyle(fontFamily: 'Roboto'),
      headlineSmall: TextStyle(fontFamily: 'Roboto'),
      titleLarge: TextStyle(fontFamily: 'Roboto'),
      titleMedium: TextStyle(fontFamily: 'Roboto'),
      titleSmall: TextStyle(fontFamily: 'Roboto'),
      bodySmall: TextStyle(fontFamily: 'Roboto'),
      labelLarge: TextStyle(fontFamily: 'Roboto'),
      labelSmall: TextStyle(fontFamily: 'Roboto'),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    colorScheme: const ColorScheme.dark(
      primary: Color(0xfff8faff),
      primaryContainer: Color(0xfff8faff),
      secondary: Color(0xff808080),
      surface: Color(0xff1e1e2f),
      onError: Color(0xff950F0F),
    ),
    useMaterial3: true,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(fontFamily: 'Roboto'),
      bodyLarge: TextStyle(fontFamily: 'Roboto'),
      displayLarge: TextStyle(fontFamily: 'Roboto'),
      displayMedium: TextStyle(fontFamily: 'Roboto'),
      displaySmall: TextStyle(fontFamily: 'Roboto'),
      headlineMedium: TextStyle(fontFamily: 'Roboto'),
      headlineSmall: TextStyle(fontFamily: 'Roboto'),
      titleLarge: TextStyle(fontFamily: 'Roboto'),
      titleMedium: TextStyle(fontFamily: 'Roboto'),
      titleSmall: TextStyle(fontFamily: 'Roboto'),
      bodySmall: TextStyle(fontFamily: 'Roboto'),
      labelLarge: TextStyle(fontFamily: 'Roboto'),
      labelSmall: TextStyle(fontFamily: 'Roboto'),
    ),
  );
}
