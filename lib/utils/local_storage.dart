import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future<void> saveValue(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
    print("saved");
  }

  static Future<String?> getValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<void> saveListValue(String key, Map<String, dynamic> value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Encode the user details to JSON
    String jsonValue = json.encode(value);
    await prefs.setString(key, jsonValue);
    print("Saved to local storage");
  }

  static Future<Object?> getListValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(key);
    if (jsonString != null && jsonString.isNotEmpty) {
      // Try decoding as a map first
      try {
        Map<String, dynamic> userDetails = json.decode(jsonString) as Map<String, dynamic>;
        return userDetails;
      } catch (e) {
        // If decoding as a map fails, return the raw JSON string
        return jsonString;
      }
    }
    return null;
  }
}
