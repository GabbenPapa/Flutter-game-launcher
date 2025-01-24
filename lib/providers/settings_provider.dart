import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  static const String _selectedLanguageKey = 'selected_language';
  String? _currentLanguage;

  String get currentLanguage => _currentLanguage ?? 'en';

  Future<void> setLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedLanguageKey, language);
    _currentLanguage = language;

    notifyListeners();
  }

  Future<String?> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString(_selectedLanguageKey);

    return _currentLanguage;
  }

  Future<void> resetLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_selectedLanguageKey);
    _currentLanguage = 'en';
    notifyListeners();
  }
}

class ThemeProvider with ChangeNotifier {
  static const String _useSystemThemeKey = 'useSystemTheme';
  static const String _isDarkThemeKey = 'isDarkTheme';

  bool _useSystemTheme = true;
  bool _isDarkTheme = false;

  bool get useSystemTheme => _useSystemTheme;
  bool get isDarkTheme => _isDarkTheme;
  Future<void> initializePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _useSystemTheme = prefs.getBool(_useSystemThemeKey) ?? true;
    _isDarkTheme = prefs.getBool(_isDarkThemeKey) ?? false;
    notifyListeners();
  }

  Future<void> setUseSystemTheme(bool useSystemTheme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_useSystemThemeKey, useSystemTheme);
    _useSystemTheme = useSystemTheme;
    notifyListeners();
  }

  Future<void> setIsDarkTheme(bool isDarkTheme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isDarkThemeKey, isDarkTheme);
    _isDarkTheme = isDarkTheme;
    notifyListeners();
  }

  Future<void> resetSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_useSystemThemeKey);
    await prefs.remove(_isDarkThemeKey);
    _useSystemTheme = true;
    _isDarkTheme = false;
    notifyListeners();
  }
}
