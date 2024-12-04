import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const primaryGreen = Color(0xFF556B2F);
  static const lightGreen = Color(0xFF8FBC8F);
  static const mintGreen = Color(0xFFF0FFF0);
  static const oliveGreen = Color(0xFF6B8E23);
  
  static ThemeData get theme => ThemeData(
    primaryColor: primaryGreen,
    scaffoldBackgroundColor: mintGreen,
    textTheme: GoogleFonts.poppinsTextTheme(),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryGreen,
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardTheme(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: oliveGreen,
    ),
  );
}