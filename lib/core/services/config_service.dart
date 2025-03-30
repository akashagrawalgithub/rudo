import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rudo/core/models/auth_models.dart';

class ConfigService {
  static Future<AuthConfig> loadAuthConfig() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/config/auth_config.json',
      );
      debugPrint('Auth config loaded: $jsonString');
      final jsonData = json.decode(jsonString);
      return AuthConfig.fromJson(jsonData['auth']);
    } catch (e) {
      debugPrint('Error loading auth config: $e');
      return AuthConfig(
        enabledMethods: [AuthMethod.email, AuthMethod.google],
        welcomeText: 'Welcome',
        loginButtonText: 'Login',
        registerButtonText: 'Register',
      );
    }
  }

  static Future<Map<String, dynamic>> loadUIConfig() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/config/ui_config.json',
      );
      debugPrint('UI config loaded');
      final jsonData = json.decode(jsonString);
      return jsonData;
    } catch (e) {
      debugPrint('Error loading UI config: $e');
      return {};
    }
  }
}
