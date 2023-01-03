import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

//App light theme
class AppLightTheme {
  final ThemeData themeData = ThemeData(
    useMaterial3: true,
    fontFamily: GoogleFonts.poppins().fontFamily,
    colorSchemeSeed: Colors.white,
    primaryTextTheme: const TextTheme(
      labelLarge: TextStyle(color: Colors.white, fontSize: 24)
    ),
  );
}