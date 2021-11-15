import 'package:audiobook/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpHelper {
  setPreference(String key, String value) {
    prefs.setString(key, value);
  }

  getPreference(String key) {
    return prefs.getString(key) ?? '';
  }
}
