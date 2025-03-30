import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rudo/core/models/theme_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const String _themeKey = 'theme_config';

  // Default theme configuration
  static final ThemeConfig _defaultConfig = ThemeConfig(
    isDarkMode: false,
    primaryColor: '#1976D2',
    accentColor: '#03A9F4',
    backgroundColor: '#FFFFFF',
    textColor: '#000000',
    borderRadius: 8.0,
    fontSize: 16.0,
  );

  // Get theme configuration
  Future<ThemeConfig> getThemeConfig() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeString = prefs.getString(_themeKey);

      if (themeString != null) {
        return ThemeConfig.fromJson(jsonDecode(themeString));
      }

      // If no saved config, try to load from assets
      try {
        final jsonString = await rootBundle.loadString(
          'assets/config/theme_config.json',
        );
        final config = ThemeConfig.fromJson(jsonDecode(jsonString));

        // Save to preferences for future use
        await saveThemeConfig(config);
        return config;
      } catch (e) {
        // If asset loading fails, use default config
        await saveThemeConfig(_defaultConfig);
        return _defaultConfig;
      }
    } catch (e) {
      return _defaultConfig;
    }
  }

  // Save theme configuration
  Future<void> saveThemeConfig(ThemeConfig config) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, jsonEncode(config.toJson()));
  }

  // Toggle dark mode
  Future<ThemeConfig> toggleDarkMode() async {
    final config = await getThemeConfig();
    final updatedConfig = ThemeConfig(
      isDarkMode: !config.isDarkMode,
      primaryColor: config.primaryColor,
      accentColor: config.accentColor,
      backgroundColor: config.backgroundColor,
      textColor: config.textColor,
      borderRadius: config.borderRadius,
      fontSize: config.fontSize,
    );
    await saveThemeConfig(updatedConfig);
    return updatedConfig;
  }

  // Get ThemeData based on config
  // Get ThemeData based on config
  ThemeData getThemeData(ThemeConfig config) {
    if (config.isDarkMode) {
      return ThemeData.dark().copyWith(
        primaryColor: _hexToColor(config.primaryColor),
        colorScheme: ColorScheme.dark(
          primary: _hexToColor(config.primaryColor),
          secondary: _hexToColor(config.accentColor),
          background: _hexToColor('#000000'), // True black background
          surface: _hexToColor('#000000'), // True black surface
          onBackground: _hexToColor('#FFFFFF'),
          onSurface: _hexToColor('#FFFFFF'),
        ),
        scaffoldBackgroundColor: _hexToColor('#000000'), // True black scaffold
        cardColor: _hexToColor('#121212'), // Dark gray for cards
        dividerColor: _hexToColor('#3E3E3E'),
        textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: _hexToColor('#FFFFFF'),
          displayColor: _hexToColor('#FFFFFF'),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: _hexToColor('#000000'), // True black app bar
          foregroundColor: _hexToColor('#FFFFFF'),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: _hexToColor('#000000'), // True black nav bar
          selectedItemColor: _hexToColor(config.primaryColor),
          unselectedItemColor: _hexToColor('#AAAAAA'),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(config.borderRadius),
            borderSide: BorderSide(color: _hexToColor('#3E3E3E')),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(config.borderRadius),
            borderSide: BorderSide(color: _hexToColor('#3E3E3E')),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(config.borderRadius),
            borderSide: BorderSide(color: _hexToColor(config.primaryColor)),
          ),
          fillColor: _hexToColor('#121212'), // Dark gray for input fields
          filled: true,
        ),
      );
    } else {
      // Light theme remains unchanged
      return ThemeData.light().copyWith(
        primaryColor: _hexToColor(config.primaryColor),
        colorScheme: ColorScheme.light(
          primary: _hexToColor(config.primaryColor),
          secondary: _hexToColor(config.accentColor),
          background: _hexToColor(config.backgroundColor),
          surface: _hexToColor('#FFFFFF'),
        ),
        scaffoldBackgroundColor: _hexToColor(config.backgroundColor),
        textTheme: ThemeData.light().textTheme.apply(
          bodyColor: _hexToColor(config.textColor),
          displayColor: _hexToColor(config.textColor),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(config.borderRadius),
          ),
        ),
      );
    }
  }

  // Helper method to convert hex to Color
  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
