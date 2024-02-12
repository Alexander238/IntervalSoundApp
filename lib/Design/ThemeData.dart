import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData mainTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.purple,
    secondary: const Color.fromARGB(255, 231, 154, 245),
    brightness: Brightness.dark,
  ),
  textTheme: TextTheme(
    titleLarge: GoogleFonts.openSans(
      fontSize: 30,
    ),
    // used for lable and number text
    bodyMedium: GoogleFonts.openSans(),
    displaySmall: GoogleFonts.openSans(),
  ),
);
