import 'package:flutter/material.dart';

enum AppThemeMode {
  emeraldIslamic,
  midnightSanctuary,
  desertSand,
  slateEther,
  obsidianPrecision,
}

class ThemeConstants {
  static const double borderRadius = 16.0;
  static const BorderRadius cardRadius = BorderRadius.all(Radius.circular(16.0));
  
  static const String fontAmiri = 'Amiri';
  static const String fontJakarta = 'Plus Jakarta Sans';

  static const List<String> themeNamesAr = [
    'الزمرد الإسلامي',
    'ملاذ الليل',
    'رمال الصحراء',
    'الإثير الصافي',
    'الديدان السوداء (أموليد)',
  ];

  static const List<String> themeNamesEn = [
    'Emerald Islamic',
    'Midnight Sanctuary',
    'Desert Sand',
    'Slate & Ether',
    'Obsidian Precision',
  ];
}
