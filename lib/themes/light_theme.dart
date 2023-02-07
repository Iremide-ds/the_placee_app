import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

//App theme
class AppTheme {
  static final ThemeData lightThemeData = ThemeData(
    useMaterial3: true,
    fontFamily: GoogleFonts.poppins().fontFamily,
    colorSchemeSeed: Colors.white,
    primaryTextTheme: const TextTheme(
      labelLarge: TextStyle(color: Colors.white, fontSize: 24)
    ),
  );
}