import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Dark Academia Color Palette
  static const Color darkBurgundy = Color(0xFF4A1E1E);
  static const Color burgundy = Color(0xFF6B2737);
  static const Color lightBurgundy = Color(0xFF8B3A4A);

  static const Color darkForestGreen = Color(0xFF1B3A2F);
  static const Color forestGreen = Color(0xFF2D5A4A);
  static const Color lightForestGreen = Color(0xFF3F7A65);

  static const Color darkNavy = Color(0xFF1A1F3A);
  static const Color navy = Color(0xFF2B3A5C);
  static const Color lightNavy = Color(0xFF3D5273);

  static const Color brass = Color(0xFFB8936D);
  static const Color darkBrass = Color(0xFF8B7355);
  static const Color lightBrass = Color(0xFFD4B896);

  static const Color parchment = Color(0xFFF4ECD8);
  static const Color darkParchment = Color(0xFFE8DCC4);

  static const Color charcoal = Color(0xFF2C2C2C);
  static const Color lightCharcoal = Color(0xFF4A4A4A);

  static const Color errorRed = Color(0xFFB33A3A);
  static const Color successGreen = Color(0xFF3A7D44);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      colorScheme: const ColorScheme.dark(
        primary: brass,
        secondary: burgundy,
        tertiary: forestGreen,
        surface: darkNavy,
        background: Color(0xFF0F1419),
        error: errorRed,
        onPrimary: darkNavy,
        onSecondary: parchment,
        onSurface: parchment,
        onBackground: parchment,
      ),

      scaffoldBackgroundColor: const Color(0xFF0F1419),

      textTheme: GoogleFonts.crimsonTextTextTheme(
        const TextTheme(
          displayLarge: TextStyle(
            fontSize: 57,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.25,
            color: parchment,
          ),
          displayMedium: TextStyle(
            fontSize: 45,
            fontWeight: FontWeight.w700,
            letterSpacing: 0,
            color: parchment,
          ),
          displaySmall: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
            color: parchment,
          ),
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
            color: parchment,
          ),
          headlineMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
            color: parchment,
          ),
          headlineSmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
            color: brass,
          ),
          titleLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            letterSpacing: 0,
            color: parchment,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.15,
            color: parchment,
          ),
          titleSmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
            color: darkParchment,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5,
            color: parchment,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.25,
            color: darkParchment,
          ),
          bodySmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.4,
            color: darkParchment,
          ),
          labelLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
            color: parchment,
          ),
          labelMedium: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            color: darkParchment,
          ),
          labelSmall: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            color: darkParchment,
          ),
        ),
      ),

      cardTheme: const CardThemeData(
        elevation: 4,
        shadowColor: Colors.black45,
      ).copyWith(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: brass.withOpacity(0.3), width: 1),
        ),
        color: darkNavy,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: brass,
          foregroundColor: darkNavy,
          elevation: 3,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.crimsonText(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: brass,
          side: const BorderSide(color: brass, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.crimsonText(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: brass,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: GoogleFonts.crimsonText(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: navy,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: brass.withOpacity(0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: brass.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: brass, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorRed),
        ),
        labelStyle: const TextStyle(color: darkParchment),
        hintStyle: TextStyle(color: darkParchment.withOpacity(0.6)),
      ),

      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: darkNavy,
        foregroundColor: parchment,
        centerTitle: true,
        titleTextStyle: GoogleFonts.crimsonText(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: brass,
          letterSpacing: 0.5,
        ),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkNavy,
        selectedItemColor: brass,
        unselectedItemColor: darkParchment,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: navy,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: brass.withOpacity(0.5), width: 1),
        ),
        titleTextStyle: GoogleFonts.crimsonText(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: brass,
        ),
        contentTextStyle: GoogleFonts.crimsonText(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: parchment,
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: navy,
        selectedColor: burgundy,
        labelStyle: GoogleFonts.crimsonText(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: parchment,
        ),
        side: BorderSide(color: brass.withOpacity(0.3)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),

      dividerTheme: DividerThemeData(
        color: brass.withOpacity(0.2),
        thickness: 1,
        space: 1,
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: brass,
        linearTrackColor: navy,
      ),
    );
  }
}
