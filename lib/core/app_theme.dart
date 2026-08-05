import 'package:flutter/material.dart';

class AppTheme {
  static const Color coral = Color(0xFFF05D50);
  static const Color orange = Color(0xFFFF9A68);
  static const Color purple = Color(0xFF6E3F73);
  static const Color plum = Color(0xFF352038);
  static const Color ink = Color(0xFF241C26);
  static const Color muted = Color(0xFF776E79);
  static const Color cream = Color(0xFFFAF7F4);
  static const Color sand = Color(0xFFF1E8E2);
  static const Color teal = Color(0xFF2F7D78);

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: coral,
      brightness: Brightness.light,
      primary: coral,
      secondary: purple,
      surface: Colors.white,
      onSurface: ink,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: cream,
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        displaySmall: TextStyle(
          color: ink,
          fontSize: 34,
          height: 1.08,
          fontWeight: FontWeight.w900,
          letterSpacing: -1.1,
        ),
        headlineMedium: TextStyle(
          color: ink,
          fontSize: 27,
          height: 1.12,
          fontWeight: FontWeight.w900,
          letterSpacing: -.7,
        ),
        titleLarge: TextStyle(
          color: ink,
          fontSize: 20,
          fontWeight: FontWeight.w900,
          letterSpacing: -.25,
        ),
        titleMedium: TextStyle(
          color: ink,
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
        bodyLarge: TextStyle(color: ink, fontSize: 16, height: 1.48),
        bodyMedium: TextStyle(color: ink, fontSize: 14, height: 1.45),
        bodySmall: TextStyle(color: muted, fontSize: 12.5, height: 1.4),
        labelLarge: TextStyle(fontWeight: FontWeight.w900),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: cream,
        foregroundColor: ink,
        titleTextStyle: TextStyle(
          color: ink,
          fontSize: 19,
          fontWeight: FontWeight.w900,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        shadowColor: Colors.black.withOpacity(.08),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: BorderSide(color: ink.withOpacity(.055)),
        ),
        margin: EdgeInsets.zero,
      ),
      dividerTheme: DividerThemeData(
        color: ink.withOpacity(.08),
        thickness: 1,
        space: 1,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: ink,
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 54),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ink,
          minimumSize: const Size(0, 52),
          side: BorderSide(color: ink.withOpacity(.14)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle: const TextStyle(color: muted),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: ink.withOpacity(.07)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: coral, width: 1.4),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        selectedColor: ink,
        side: BorderSide(color: ink.withOpacity(.08)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        labelStyle: const TextStyle(fontWeight: FontWeight.w800),
        secondaryLabelStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: coral,
      brightness: Brightness.dark,
      primary: const Color(0xFFFF7E71),
      secondary: const Color(0xFFD7A8DF),
      surface: const Color(0xFF241F26),
      onSurface: const Color(0xFFF7F0F6),
    );

    return light().copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFF171419),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Color(0xFF171419),
        foregroundColor: Color(0xFFF7F0F6),
        titleTextStyle: TextStyle(
          color: Color(0xFFF7F0F6),
          fontSize: 19,
          fontWeight: FontWeight.w900,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: const Color(0xFF241F26),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: BorderSide(color: Colors.white.withOpacity(.07)),
        ),
        margin: EdgeInsets.zero,
      ),
      textTheme: light().textTheme.apply(
            bodyColor: const Color(0xFFF7F0F6),
            displayColor: const Color(0xFFF7F0F6),
          ),
      inputDecorationTheme: light().inputDecorationTheme.copyWith(
            fillColor: const Color(0xFF241F26),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.white.withOpacity(.08)),
            ),
          ),
      chipTheme: light().chipTheme.copyWith(
            backgroundColor: const Color(0xFF241F26),
            side: BorderSide(color: Colors.white.withOpacity(.08)),
          ),
    );
  }
}
