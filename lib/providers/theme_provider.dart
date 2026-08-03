import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/theme_constants.dart';
import '../theme/app_themes.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _prefKey = 'selected_theme_mode';
  AppThemeMode _currentThemeMode = AppThemeMode.emeraldIslamic;

  AppThemeMode get currentThemeMode => _currentThemeMode;

  ThemeData get themeData => AppThemes.getTheme(_currentThemeMode);

  ThemeProvider() {
    _loadThemeFromPrefs();
  }

  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(_prefKey) ?? 0;
    if (index >= 0 && index < AppThemeMode.values.length) {
      _currentThemeMode = AppThemeMode.values[index];
      notifyListeners();
    }
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    _currentThemeMode = mode;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefKey, mode.index);
  }
}
