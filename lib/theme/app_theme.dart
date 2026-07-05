import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Cheerful Project Colors ─────────────────────────────
  static const List<Color> projectColors = [
    Color(0xFF9E9E9E), // Neutral Gray (default — ideas)
    Color(0xFFFF6B6B), // Coral Red
    Color(0xFFFFB347), // Mango Orange
    Color(0xFFFFD93D), // Sunny Yellow
    Color(0xFF6BCB77), // Fresh Green
    Color(0xFF4D96FF), // Sky Blue
    Color(0xFF9B59B6), // Soft Purple
    Color(0xFFFF6B9D), // Rose Pink
    Color(0xFF00D2D3), // Teal
  ];

  static const List<Color> projectColorsLight = [
    Color(0xFFEEEEEE), // Neutral Gray light
    Color(0xFFFFE0E0), // Coral Red light
    Color(0xFFFFE8CC), // Mango Orange light
    Color(0xFFFFF4CC), // Sunny Yellow light
    Color(0xFFD4F5D9), // Fresh Green light
    Color(0xFFD4E6FF), // Sky Blue light
    Color(0xFFE8D5F5), // Soft Purple light
    Color(0xFFFFD6E7), // Rose Pink light
    Color(0xFFCCF5F5), // Teal light
  ];

  static Color getProjectColor(int index) {
    return projectColors[index % projectColors.length];
  }

  static Color getProjectColorLight(int index) {
    return projectColorsLight[index % projectColorsLight.length];
  }

  // ── Theme ───────────────────────────────────────────────
  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.nunitoTextTheme();

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFFF6B6B),
        brightness: Brightness.light,
      ),
      textTheme: baseTextTheme.copyWith(
        headlineLarge: baseTextTheme.headlineLarge?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
        headlineSmall: baseTextTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
        ),
        titleLarge: baseTextTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
        titleMedium: baseTextTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(
          height: 1.6,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          height: 1.5,
        ),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 1,
        titleTextStyle: GoogleFonts.nunito(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF2D3436),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 4,
        highlightElevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFFFF6B6B),
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        hintStyle: GoogleFonts.nunito(
          color: const Color(0xFFB2BEC3),
          fontWeight: FontWeight.w500,
        ),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
