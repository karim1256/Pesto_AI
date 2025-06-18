import 'package:shared_preferences/shared_preferences.dart';

class CacheNetwork {
  static SharedPreferences? _sharedPref;

  static Future<void> cacheInitialization() async {
    _sharedPref = await SharedPreferences.getInstance();
  }

  static Future<bool> insertToCache(String key, String value) async {
    if (_sharedPref == null) throw Exception("SharedPreferences not initialized");
    return await _sharedPref!.setString(key, value);
  }

  static String? getCacheData(String key) {
    if (_sharedPref == null) throw Exception("SharedPreferences not initialized");
    return _sharedPref!.getString(key) ;
  }

  static Future<bool> deleteCacheData(String key) async {
    if (_sharedPref == null) throw Exception("SharedPreferences not initialized");
    return await _sharedPref!.remove(key);
  }
}
