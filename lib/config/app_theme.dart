import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFF2E7D32); // Green
  static const Color secondaryColor = Color(0xFF1565C0); // Blue
  static const Color tertiaryColor = Color(0xFFFF6F00); // Orange
  static const Color errorColor = Color(0xFFD32F2F); // Red
  static const Color backgroundColor = Color(0xFFFAFAFA);
  static const Color surfaceColor = Color(0xFFFFFFFF);

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: tertiaryColor,
      error: errorColor,
      surface: surfaceColor,
      surfaceDim: backgroundColor,
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.cairo(fontSize: 32, fontWeight: FontWeight.bold),
      displayMedium: GoogleFonts.cairo(fontSize: 28, fontWeight: FontWeight.bold),
      displaySmall: GoogleFonts.cairo(fontSize: 24, fontWeight: FontWeight.bold),
      headlineMedium: GoogleFonts.cairo(fontSize: 20, fontWeight: FontWeight.bold),
      headlineSmall: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.w600),
      titleLarge: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w600),
      labelLarge: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w500),
      bodyLarge: GoogleFonts.cairo(fontSize: 16),
      bodyMedium: GoogleFonts.cairo(fontSize: 14),
      bodySmall: GoogleFonts.cairo(fontSize: 12),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceColor,
      foregroundColor: Colors.black87,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.cairo(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      elevation: 8,
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: tertiaryColor,
      error: errorColor,
      surface: const Color(0xFF121212),
      surfaceDim: const Color(0xFF1E1E1E),
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.cairo(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      displayMedium: GoogleFonts.cairo(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      displaySmall: GoogleFonts.cairo(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineMedium: GoogleFonts.cairo(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineSmall: GoogleFonts.cairo(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      titleLarge: GoogleFonts.cairo(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      labelLarge: GoogleFonts.cairo(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      bodyLarge: GoogleFonts.cairo(fontSize: 16, color: Colors.white70),
      bodyMedium: GoogleFonts.cairo(fontSize: 14, color: Colors.white70),
      bodySmall: GoogleFonts.cairo(fontSize: 12, color: Colors.white54),
    ),
  );
}
