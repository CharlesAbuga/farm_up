import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme.light(
    surface: Colors.white,
    onSurface: Colors.black,
    primary: Color.fromARGB(255, 115, 212, 116),
    onPrimary: Colors.black,
    secondary: Color.fromARGB(255, 13, 100, 17),
    onSecondary: Colors.white,
    tertiary: Colors.green,
    error: Colors.red,
    outline: Color(0xFF424242),
    inverseSurface: Colors.orange,
  ),
);

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme.dark(
    surface: Colors.black,
    onSurface: Colors.white,
    primary: Color.fromARGB(255, 115, 212, 116),
    onPrimary: Colors.white,
    secondary: Color.fromARGB(255, 13, 100, 17),
    onSecondary: Colors.black,
    tertiary: Colors.green,
    error: Colors.red,
    outline: Colors.white,
    inverseSurface: Colors.orange,
  ),
);
