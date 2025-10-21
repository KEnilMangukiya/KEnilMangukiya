import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  final SharedPreferences prefs;
  StorageService(this.prefs);

  Future<bool> setBool(String key, bool value) async => prefs.setBool(key, value);
  bool getBool(String key, {bool defaultValue = false}) => prefs.getBool(key) ?? defaultValue;

  Future<bool> setString(String key, String value) async => prefs.setString(key, value);
  String? getString(String key) => prefs.getString(key);

  Future<bool> setJson(String key, Object value) async => prefs.setString(key, jsonEncode(value));
  T? getJson<T>(String key, T Function(Object? data) mapper) {
    final raw = prefs.getString(key);
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw);
      return mapper(decoded);
    } catch (_) {
      return null;
    }
  }
}
