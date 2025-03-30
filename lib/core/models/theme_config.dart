import 'package:flutter/material.dart';

class ThemeConfig {
  final bool isDarkMode;
  final String primaryColor;
  final String accentColor;
  final String backgroundColor;
  final String textColor;
  final double borderRadius;
  final double fontSize;

  ThemeConfig({
    this.isDarkMode = false,
    this.primaryColor = '#1976D2',
    this.accentColor = '#03A9F4',
    this.backgroundColor = '#FFFFFF',
    this.textColor = '#000000',
    this.borderRadius = 8.0,
    this.fontSize = 16.0,
  });

  factory ThemeConfig.fromJson(Map<String, dynamic> json) {
    return ThemeConfig(
      isDarkMode: json['isDarkMode'] ?? false,
      primaryColor: json['primaryColor'] ?? '#1976D2',
      accentColor: json['accentColor'] ?? '#03A9F4',
      backgroundColor: json['backgroundColor'] ?? '#FFFFFF',
      textColor: json['textColor'] ?? '#000000',
      borderRadius: json['borderRadius']?.toDouble() ?? 8.0,
      fontSize: json['fontSize']?.toDouble() ?? 16.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isDarkMode': isDarkMode,
      'primaryColor': primaryColor,
      'accentColor': accentColor,
      'backgroundColor': backgroundColor,
      'textColor': textColor,
      'borderRadius': borderRadius,
      'fontSize': fontSize,
    };
  }

  // Helper method to convert hex to Color
  Color hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
