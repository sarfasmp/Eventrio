import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:event_and_voucher/theme/app_typography.dart';

class AppTheme {
  // Primary Colors
  static const Color primaryOrange = Color(0xFFF76810);
  
  // Secondary Colors
  static const Color secondaryYellow = Color(0xFFFBBE47);
  static const Color secondaryBlue = Color(0xFF3E82F7);
  static const Color secondaryGreen = Color(0xFF29D697);
  static const Color secondaryDarkOrange = Color(0xFF8C3700);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFFF0F0EE);
  static const Color grey2 = Color(0xFFE1E1E1);
  static const Color softDarkish = Color(0xFF4A4D55);
  
  // Gradient/Linear Colors
  static const Color orangeLinear = Color(0xFFF76810);
  static const Color blackLinear = Color(0xFF171924);
  static const Color buttonLinear = Color(0xFF20222C);
  static Color dividerLinear = const Color(0xFF20222C).withValues(alpha: 0.2);
  
  // Text Colors
  static const Color textBlack = Color(0xFF20222C);
  static const Color textWhite = Color(0xFFFDFDFD);
  
  // State Colors
  static const Color infoColor = Color(0xFF2F80ED);
  static const Color successColor = Color(0xFF27AE60);
  static const Color warningColor = Color(0xFFE28938);
  static const Color errorColor = Color(0xFFEB5757);
  
  // Background Colors
  static const Color backgroundInfo = Color(0xFF2F80ED);
  
  // Legacy compatibility (using primary orange)
  static const Color primaryColor = primaryOrange;
  static const Color secondaryColor = secondaryYellow;
  static const Color accentColor = secondaryBlue;
  
  // Gradients
  static LinearGradient get primaryGradient => const LinearGradient(
        colors: [primaryOrange, secondaryDarkOrange],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get buttonGradient => const LinearGradient(
        colors: [buttonLinear, blackLinear],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get orangeGradient => const LinearGradient(
        colors: [primaryOrange, secondaryYellow],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  // Theme data
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: AppTypography.fontFamily,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryOrange,
      brightness: Brightness.light,
      primary: primaryOrange,
      secondary: secondaryYellow,
      tertiary: secondaryBlue,
      error: errorColor,
      surface: white,
      onPrimary: textWhite,
      onSecondary: textBlack,
      onSurface: textBlack,
    ),
    scaffoldBackgroundColor: white,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: white,
      foregroundColor: textBlack,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: textBlack),
      titleTextStyle: AppTypography.heading02.copyWith(
        color: textBlack,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      color: white,
      shadowColor: textBlack.withValues(alpha: 0.1),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
        backgroundColor: primaryOrange,
        foregroundColor: textWhite,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: grey2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: grey2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primaryOrange, width: 2),
      ),
      filled: true,
      fillColor: white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      backgroundColor: primaryOrange.withValues(alpha: 0.1),
      labelStyle: const TextStyle(color: primaryOrange),
    ),
    textTheme: GoogleFonts.interTextTheme().copyWith(
      displayLarge: AppTypography.heading01,
      displayMedium: AppTypography.heading02,
      headlineLarge: AppTypography.heading03,
      headlineMedium: AppTypography.heading04,
      headlineSmall: AppTypography.heading05,
      titleLarge: AppTypography.heading06,
      bodyLarge: AppTypography.body01,
      bodyMedium: AppTypography.body02,
      bodySmall: AppTypography.body03,
      labelLarge: AppTypography.button01,
      labelMedium: AppTypography.button02,
      labelSmall: AppTypography.button03,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: AppTypography.fontFamily,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryOrange,
      brightness: Brightness.dark,
      primary: primaryOrange,
      secondary: secondaryYellow,
      tertiary: secondaryBlue,
      error: errorColor,
      surface: buttonLinear,
      onPrimary: textWhite,
      onSecondary: textBlack,
      onSurface: textWhite,
    ),
    scaffoldBackgroundColor: blackLinear,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: buttonLinear,
      foregroundColor: textWhite,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: textWhite),
      titleTextStyle: AppTypography.heading02.copyWith(
        color: textWhite,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      color: buttonLinear,
      shadowColor: primaryOrange.withValues(alpha: 0.3),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
        backgroundColor: primaryOrange,
        foregroundColor: textWhite,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: softDarkish),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: softDarkish),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primaryOrange, width: 2),
      ),
      filled: true,
      fillColor: buttonLinear,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      backgroundColor: primaryOrange.withValues(alpha: 0.2),
      labelStyle: const TextStyle(color: primaryOrange),
    ),
    textTheme: GoogleFonts.interTextTheme().copyWith(
      displayLarge: AppTypography.heading01.copyWith(color: textWhite),
      displayMedium: AppTypography.heading02.copyWith(color: textWhite),
      headlineLarge: AppTypography.heading03.copyWith(color: textWhite),
      headlineMedium: AppTypography.heading04.copyWith(color: textWhite),
      headlineSmall: AppTypography.heading05.copyWith(color: textWhite),
      titleLarge: AppTypography.heading06.copyWith(color: textWhite),
      bodyLarge: AppTypography.body01.copyWith(color: textWhite),
      bodyMedium: AppTypography.body02.copyWith(color: textWhite),
      bodySmall: AppTypography.body03.copyWith(color: textWhite),
      labelLarge: AppTypography.button01.copyWith(color: textWhite),
      labelMedium: AppTypography.button02.copyWith(color: textWhite),
      labelSmall: AppTypography.button03.copyWith(color: textWhite),
    ),
  );
}
