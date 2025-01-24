import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroProvider with ChangeNotifier {
  static const String _keyIntroCompleted = 'introCompleted';

  static Future<void> setIntroCompleted(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIntroCompleted, value);
  }

  static Future<bool> getIntroCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIntroCompleted) ?? false;
  }

  static Future<void> resetIntroCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyIntroCompleted);
  }
}
