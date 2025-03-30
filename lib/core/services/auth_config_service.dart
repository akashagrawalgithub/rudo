import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:rudo/core/models/auth_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthConfigService {
  static const String _configKey = 'auth_config';

  static final AuthConfig _defaultConfig = AuthConfig(
    enableGoogleAuth: true,
    enableAppleAuth: true,
    enablePhoneAuth: true,
    enableEmailAuth: true,
    phoneAuthTestNumber: '+918957792911',
  );

  Future<AuthConfig> getAuthConfig() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final configString = prefs.getString(_configKey);

      if (configString != null) {
        return AuthConfig.fromJson(jsonDecode(configString));
      }

      try {
        final jsonString = await rootBundle.loadString(
          'assets/config/auth_config.json',
        );
        final config = AuthConfig.fromJson(jsonDecode(jsonString));

        await saveAuthConfig(config);
        return config;
      } catch (e) {
        await saveAuthConfig(_defaultConfig);
        return _defaultConfig;
      }
    } catch (e) {
      return _defaultConfig;
    }
  }

  Future<void> saveAuthConfig(AuthConfig config) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_configKey, jsonEncode(config.toJson()));
  }
}
