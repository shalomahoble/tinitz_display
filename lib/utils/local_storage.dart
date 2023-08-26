// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future restore(String key) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return (sharedPreferences.get(key) ?? false);
  }

  static add(String key, dynamic value) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    if (value is bool) {
      sharedPreferences.setBool(key, value);
    }
    if (value is String) {
      sharedPreferences.setString(key, value);
    }
    if (value is int) {
      sharedPreferences.setInt(key, value);
    }
    if (value is double) {
      sharedPreferences.setDouble(key, value);
    } else if (value is List<String>) {
      sharedPreferences.setStringList(key, value);
    }
  }

  static remove(dynamic key) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.remove(key);
  }
}
