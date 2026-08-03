import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme_constants.dart';

class AppThemes {
  // 1. EMERALD ISLAMIC
  static ThemeData get emeraldIslamic {
    const primary = Color(0xFF0F5132);
    const secondary = Color(0xFFD4AF37); // Gold
    const scaffoldBg = Color(0xFFFCF9F8);
    const surface = Color(0xFFFFFFFF);
    const onSurface = Color(0xFF1E2922);

    final textTheme = GoogleFonts.plusJakartaSansTextTheme(
      ThemeData.light().textTheme,
    ).apply(bodyColor: onSurface, displayColor: onSurface);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: scaffoldBg,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: secondary,
        surface: surface,
        onSurface: onSurface,
        primaryContainer: Color(0xFFE8F5E9),
        onPrimaryContainer: primary,
      ),
      textTheme: textTheme,
      cardTheme: const CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: ThemeConstants.cardRadius,
          side: BorderSide(color: Color(0xFFE0E7E1), width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: scaffoldBg,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: primary),
        titleTextStyle: TextStyle(
          color: primary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Amiri',
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: Color(0xFF7A8B7E),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: primary,
        inactiveTrackColor: Color(0xFFC8E6C9),
        thumbColor: secondary,
      ),
    );
  }

  // 2. MIDNIGHT SANCTUARY
  static ThemeData get midnightSanctuary {
    const primary = Color(0xFFFFD700); // Gold
    const scaffoldBg = Color(0xFF070A13);
    const surface = Color(0xFF0F172A);
    const onSurface = Color(0xFFF8FAFC);

    final textTheme = GoogleFonts.plusJakartaSansTextTheme(
      ThemeData.dark().textTheme,
    ).apply(bodyColor: onSurface, displayColor: onSurface);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: scaffoldBg,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: Color(0xFF38BDF8),
        surface: surface,
        onSurface: onSurface,
        primaryContainer: Color(0xFF1E293B),
        onPrimaryContainer: primary,
      ),
      textTheme: textTheme,
      cardTheme: const CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: ThemeConstants.cardRadius,
          side: BorderSide(color: Color(0xFF334155), width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: scaffoldBg,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: primary),
        titleTextStyle: TextStyle(
          color: primary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: Color(0xFF64748B),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: primary,
        inactiveTrackColor: Color(0xFF334155),
        thumbColor: primary,
      ),
    );
  }

  // 3. DESERT SAND
  static ThemeData get desertSand {
    const primary = Color(0xFFB35C41); // Terracotta
    const secondary = Color(0xFF8B4513); // Warm Earth
    const scaffoldBg = Color(0xFFF7F1E5);
    const surface = Color(0xFFFFFDF9);
    const onSurface = Color(0xFF2C221E);

    final textTheme = GoogleFonts.sourceSerif4TextTheme(
      ThemeData.light().textTheme,
    ).apply(bodyColor: onSurface, displayColor: onSurface);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: scaffoldBg,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: secondary,
        surface: surface,
        onSurface: onSurface,
        primaryContainer: Color(0xFFFCEBE6),
        onPrimaryContainer: primary,
      ),
      textTheme: textTheme,
      cardTheme: const CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: ThemeConstants.cardRadius,
          side: BorderSide(color: Color(0xFFEADBCE), width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: scaffoldBg,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: primary),
        titleTextStyle: TextStyle(
          color: primary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: Color(0xFFA38F85),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: primary,
        inactiveTrackColor: Color(0xFFEADBCE),
        thumbColor: secondary,
      ),
    );
  }

  // 4. SLATE & ETHER
  static ThemeData get slateEther {
    const primary = Color(0xFF2A4365); // Slate Blue
    const secondary = Color(0xFF3182CE); // Ether Accent
    const scaffoldBg = Color(0xFFFAFAFA);
    const surface = Color(0xFFFFFFFF);
    const onSurface = Color(0xFF1A202C);

    final textTheme = GoogleFonts.interTextTheme(
      ThemeData.light().textTheme,
    ).apply(bodyColor: onSurface, displayColor: onSurface);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: scaffoldBg,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: secondary,
        surface: surface,
        onSurface: onSurface,
        primaryContainer: Color(0xFFEBF8FF),
        onPrimaryContainer: primary,
      ),
      textTheme: textTheme,
      cardTheme: const CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: ThemeConstants.cardRadius,
          side: BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: scaffoldBg,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: primary),
        titleTextStyle: TextStyle(
          color: primary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: secondary,
        unselectedItemColor: Color(0xFFA0AEC0),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: secondary,
        inactiveTrackColor: Color(0xFFE2E8F0),
        thumbColor: primary,
      ),
    );
  }

  // 5. OBSIDIAN PRECISION (AMOLED DARK)
  static ThemeData get obsidianPrecision {
    const primary = Color(0xFFE2E2E2); // High Contrast White
    const secondary = Color(0xFF90CAF9);
    const scaffoldBg = Color(0xFF000000); // Pure Black
    const surface = Color(0xFF121212);
    const onSurface = Color(0xFFFFFFFF);

    final textTheme = GoogleFonts.jetBrainsMonoTextTheme(
      ThemeData.dark().textTheme,
    ).apply(bodyColor: onSurface, displayColor: onSurface);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: scaffoldBg,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: surface,
        onSurface: onSurface,
        primaryContainer: Color(0xFF222222),
        onPrimaryContainer: primary,
      ),
      textTheme: textTheme,
      cardTheme: const CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: ThemeConstants.cardRadius,
          side: BorderSide(color: Color(0xFF2C2C2C), width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: scaffoldBg,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: primary),
        titleTextStyle: TextStyle(
          color: primary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: Color(0xFF666666),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: primary,
        inactiveTrackColor: Color(0xFF333333),
        thumbColor: primary,
      ),
    );
  }

  static ThemeData getTheme(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.emeraldIslamic:
        return emeraldIslamic;
      case AppThemeMode.midnightSanctuary:
        return midnightSanctuary;
      case AppThemeMode.desertSand:
        return desertSand;
      case AppThemeMode.slateEther:
        return slateEther;
      case AppThemeMode.obsidianPrecision:
        return obsidianPrecision;
    }
  }
}
