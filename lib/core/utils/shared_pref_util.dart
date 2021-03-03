import 'dart:convert';

import 'package:ams/core/models/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefUtil {
  static String _bleAddress = "bleAddress";
  static String _settings = "settings";
  static SharedPreferences sharedPreferences;

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static String getBleDeviceAddress() {
    return sharedPreferences.get(_bleAddress);
  }

  static Future<bool> setBleDeviceAddress(String address) {
    return sharedPreferences.setString(_bleAddress, address);
  }

  static setSettings(Settings settings) {
    sharedPreferences.setString(_settings, jsonEncode(settings.toJson()));
  }

  static Settings getSettings() {
    if (sharedPreferences.getString(_settings) != null) {
      return Settings.fromJson(jsonDecode(sharedPreferences.getString(_settings)));
    } else {
      return null;
    }
  }
}
