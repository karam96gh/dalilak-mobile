import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Brand Colors ────────────────────────────────────────────────────
  static const Color primary      = Color(0xFF5C35C9); // Indigo/Violet
  static const Color primaryDark  = Color(0xFF3D1FA8);
  static const Color secondary    = Color(0xFF00BFA5); // Teal accent
  static const Color accent       = Color(0xFFFF6B35); // Orange
  static const Color error        = Color(0xFFE53935);

  // Light palette
  static const Color bgLight      = Color(0xFFF5F4FA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight    = Color(0xFFFFFFFF);

  // Dark palette
  static const Color bgDark       = Color(0xFF0F0D1A);
  static const Color surfaceDark  = Color(0xFF1C192E);
  static const Color cardDark     = Color(0xFF252236);

  // ── Gradients ───────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF5C35C9), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient headerGradient = LinearGradient(
    colors: [Color(0xFF4527A0), Color(0xFF5C35C9), Color(0xFF7C4DFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Text Theme ──────────────────────────────────────────────────────
  static TextTheme _buildTextTheme(Color base) => TextTheme(
    displayLarge:  GoogleFonts.cairo(fontSize: 32, fontWeight: FontWeight.w800, color: base),
    displayMedium: GoogleFonts.cairo(fontSize: 28, fontWeight: FontWeight.w700, color: base),
    displaySmall:  GoogleFonts.cairo(fontSize: 24, fontWeight: FontWeight.w700, color: base),
    headlineLarge: GoogleFonts.cairo(fontSize: 22, fontWeight: FontWeight.w700, color: base),
    headlineMedium:GoogleFonts.cairo(fontSize: 20, fontWeight: FontWeight.w700, color: base),
    headlineSmall: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.w600, color: base),
    titleLarge:    GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w600, color: base),
    titleMedium:   GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.w600, color: base),
    titleSmall:    GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w500, color: base),
    bodyLarge:     GoogleFonts.cairo(fontSize: 16, color: base.withOpacity(0.9)),
    bodyMedium:    GoogleFonts.cairo(fontSize: 14, color: base.withOpacity(0.85)),
    bodySmall:     GoogleFonts.cairo(fontSize: 12, color: base.withOpacity(0.65)),
    labelLarge:    GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w600, color: base),
    labelSmall:    GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w500, color: base.withOpacity(0.7)),
  );

  // ── Light Theme ─────────────────────────────────────────────────────
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: primary,
      secondary: secondary,
      tertiary: accent,
      error: error,
      surface: surfaceLight,
      surfaceContainerHighest: bgLight,
    ),
    scaffoldBackgroundColor: bgLight,
    textTheme: _buildTextTheme(const Color(0xFF1A1730)),
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceLight,
      foregroundColor: const Color(0xFF1A1730),
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.black12,
      titleTextStyle: GoogleFonts.cairo(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF1A1730),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: primary,
      unselectedItemColor: Color(0xFF9E9BB8),
      backgroundColor: surfaceLight,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: surfaceLight,
      indicatorColor: primary.withOpacity(0.12),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return GoogleFonts.cairo(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: primary,
          );
        }
        return GoogleFonts.cairo(
          fontSize: 12,
          color: const Color(0xFF9E9BB8),
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: primary, size: 24);
        }
        return const IconThemeData(color: Color(0xFF9E9BB8), size: 24);
      }),
    ),
    cardTheme: CardTheme(
      color: cardLight,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFEEEBF8), width: 1),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: GoogleFonts.cairo(fontWeight: FontWeight.w600, fontSize: 15),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primary,
        side: const BorderSide(color: primary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFEEEBF8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      hintStyle: GoogleFonts.cairo(color: const Color(0xFF9E9BB8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFFEEEBF8),
      selectedColor: primary.withOpacity(0.15),
      labelStyle: GoogleFonts.cairo(fontSize: 13),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFFEEEBF8),
      thickness: 1,
      space: 0,
    ),
  );

  // ── Dark Theme ──────────────────────────────────────────────────────
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: const Color(0xFF8B5CF6),
      secondary: secondary,
      tertiary: accent,
      error: error,
      surface: surfaceDark,
      surfaceContainerHighest: bgDark,
    ),
    scaffoldBackgroundColor: bgDark,
    textTheme: _buildTextTheme(const Color(0xFFEDE9F9)),
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceDark,
      foregroundColor: const Color(0xFFEDE9F9),
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.cairo(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: const Color(0xFFEDE9F9),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Color(0xFF8B5CF6),
      unselectedItemColor: Color(0xFF6B6880),
      backgroundColor: surfaceDark,
      elevation: 0,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: surfaceDark,
      indicatorColor: const Color(0xFF8B5CF6).withOpacity(0.2),
    ),
    cardTheme: CardTheme(
      color: cardDark,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFF2E2A45), width: 1),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF8B5CF6),
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.cairo(fontWeight: FontWeight.w600, fontSize: 15),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: cardDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      hintStyle: GoogleFonts.cairo(color: const Color(0xFF6B6880)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: cardDark,
      labelStyle: GoogleFonts.cairo(fontSize: 13, color: Colors.white70),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF2E2A45),
      thickness: 1,
      space: 0,
    ),
  );
}
