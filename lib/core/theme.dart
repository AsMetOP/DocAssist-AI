import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFF2F6BFF);
  static const Color softBlue = Color(0xFFEAF0FF);
  static const Color bg = Color(0xFFF3F6FB);
  static const Color textGrey = Color(0xFF6B7280);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: bg,
      primaryColor: primary,
      textTheme: GoogleFonts.interTextTheme().copyWith(
        bodyMedium: const TextStyle(
          color: Color(0xFF1F2937),
          height: 1.5,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static BoxDecoration cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(24),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(.04),
        blurRadius: 20,
        offset: const Offset(0, 8),
      )
    ],
  );
}