import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsKeys {
  static const String _keyIsAppFirstTimeLaunched = "isAppFirstTimeLaunched";
  static SharedPreferences? _prefs;

  static get instance => const SharedPrefsKeys._();

  static get prefs => _prefs;

  const SharedPrefsKeys._();

  static Future<void> init() async {
    if (_prefs != null) return;
    _prefs = await SharedPreferences.getInstance();
  }

  static bool get isAppFirstTimeLaunched {
    return _prefs?.getBool(_keyIsAppFirstTimeLaunched) ?? true;
  }

  static Future<void> setAppFirstTimeLaunched(bool value) async {
    await _prefs?.setBool(_keyIsAppFirstTimeLaunched, value);
  }
}
