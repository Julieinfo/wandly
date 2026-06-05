import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Gryffindor House Colors
const Color _primaryRed = Color(0xFFAE0001);
const Color _accentGold = Color(0xFFD3A625);
const Color _darkBurgundy = Color(0xFF2C0000);
const Color _veryDarkBackground = Color(0xFF1A0000);
const Color _creamWhite = Color(0xFFF5E6C8);

/// ThemeData complet pour le thème Gryffondor
final ThemeData gryffondorTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,

  // ColorScheme avec les couleurs Gryffondor
  colorScheme: ColorScheme.dark(
    primary: _primaryRed,
    onPrimary: _creamWhite,
    secondary: _accentGold,
    onSecondary: _darkBurgundy,
    tertiary: _darkBurgundy,
    onTertiary: _creamWhite,
    surface: _veryDarkBackground,
    onSurface: _creamWhite,
    error: Color(0xFFFF6B6B),
    onError: Colors.white,
    outline: _accentGold,
  ),

  // Scaffold Background Color
  scaffoldBackgroundColor: _veryDarkBackground,

  // AppBar Theme
  appBarTheme: AppBarTheme(
    backgroundColor: _darkBurgundy,
    foregroundColor: _creamWhite,
    elevation: 8,
    shadowColor: Colors.black,
    centerTitle: true,
    titleTextStyle: GoogleFonts.cinzel(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: _creamWhite,
      letterSpacing: 1.2,
    ),
    iconTheme: IconThemeData(color: _creamWhite),
  ),

  // Card Theme
  cardTheme: CardThemeData(
    color: _darkBurgundy,
    elevation: 6,
    shadowColor: _primaryRed.withValues(alpha: 0.5),
    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: _accentGold, width: 1.5),
    ),
  ),

  // Text Theme
  textTheme: TextTheme(
    // Display styles - using Cinzel for prominent text
    displayLarge: GoogleFonts.cinzel(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: _creamWhite,
      letterSpacing: 1.5,
    ),
    displayMedium: GoogleFonts.cinzel(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: _creamWhite,
      letterSpacing: 1.2,
    ),
    displaySmall: GoogleFonts.cinzel(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: _creamWhite,
      letterSpacing: 1,
    ),

    // Headline styles - using Cinzel
    headlineLarge: GoogleFonts.cinzel(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: _accentGold,
      letterSpacing: 0.8,
    ),
    headlineMedium: GoogleFonts.cinzel(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: _accentGold,
      letterSpacing: 0.6,
    ),
    headlineSmall: GoogleFonts.cinzel(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: _accentGold,
    ),

    // Title styles - using Cinzel
    titleLarge: GoogleFonts.cinzel(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: _creamWhite,
    ),
    titleMedium: GoogleFonts.cinzel(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: _creamWhite,
    ),
    titleSmall: GoogleFonts.cinzel(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: _accentGold,
    ),

    // Body styles - using Raleway for readability
    bodyLarge: GoogleFonts.raleway(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: _creamWhite,
      height: 1.5,
    ),
    bodyMedium: GoogleFonts.raleway(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: _creamWhite,
      height: 1.5,
    ),
    bodySmall: GoogleFonts.raleway(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: _creamWhite.withValues(alpha: 0.8),
      height: 1.4,
    ),

    // Label styles - using Raleway
    labelLarge: GoogleFonts.raleway(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: _creamWhite,
      letterSpacing: 0.5,
    ),
    labelMedium: GoogleFonts.raleway(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: _creamWhite,
      letterSpacing: 0.3,
    ),
    labelSmall: GoogleFonts.raleway(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: _creamWhite.withValues(alpha: 0.7),
    ),
  ),

  // Elevated Button Theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: _primaryRed,
      foregroundColor: _creamWhite,
      elevation: 8,
      shadowColor: _primaryRed.withValues(alpha: 0.6),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: _accentGold, width: 1.5),
      ),
      textStyle: GoogleFonts.cinzel(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.8,
      ),
    ),
  ),

  // Text Button Theme
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: _accentGold,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      textStyle: GoogleFonts.raleway(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    ),
  ),

  // Outlined Button Theme
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: _accentGold,
      backgroundColor: _darkBurgundy,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      side: BorderSide(color: _accentGold, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      textStyle: GoogleFonts.raleway(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    ),
  ),

  // Input Decoration Theme
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: _darkBurgundy,
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: _accentGold, width: 1.5),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: _accentGold, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: _primaryRed, width: 2),
    ),
    hintStyle: GoogleFonts.raleway(
      fontSize: 14,
      color: _creamWhite.withValues(alpha: 0.6),
      fontWeight: FontWeight.w400,
    ),
    labelStyle: GoogleFonts.raleway(
      fontSize: 14,
      color: _accentGold,
      fontWeight: FontWeight.w500,
    ),
    errorStyle: GoogleFonts.raleway(
      fontSize: 12,
      color: Color(0xFFFF6B6B),
      fontWeight: FontWeight.w400,
    ),
  ),

  // Icon Theme
  iconTheme: IconThemeData(color: _accentGold, size: 24),

  // FloatingActionButton Theme
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: _primaryRed,
    foregroundColor: _creamWhite,
    elevation: 8,
    highlightElevation: 12,
  ),

  // Bottom AppBar Theme
  bottomAppBarTheme: BottomAppBarThemeData(
    color: _darkBurgundy,
    elevation: 8,
    shadowColor: Colors.black,
  ),

  // Dialog Theme
  dialogTheme: DialogThemeData(
    backgroundColor: _darkBurgundy,
    elevation: 12,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: _accentGold, width: 2),
    ),
    titleTextStyle: GoogleFonts.cinzel(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: _creamWhite,
      letterSpacing: 0.8,
    ),
    contentTextStyle: GoogleFonts.raleway(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: _creamWhite,
    ),
  ),

  // Chip Theme
  chipTheme: ChipThemeData(
    backgroundColor: _darkBurgundy,
    selectedColor: _primaryRed,
    secondarySelectedColor: _accentGold,
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    labelStyle: GoogleFonts.raleway(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: _creamWhite,
    ),
    secondaryLabelStyle: GoogleFonts.raleway(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: _creamWhite,
    ),
    brightness: Brightness.dark,
  ),

  // Progress Indicator Theme
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: _accentGold,
    linearTrackColor: _darkBurgundy,
    circularTrackColor: _darkBurgundy,
  ),

  // Divider Theme
  dividerTheme: DividerThemeData(
    color: _accentGold.withValues(alpha: 0.3),
    thickness: 1,
    space: 16,
  ),
);
