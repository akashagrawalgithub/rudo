import 'package:flutter/material.dart';
import 'package:rudo/core/services/config_service.dart';
import 'package:rudo/ui/components/dynamic_ui_factory.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Future<Map<String, dynamic>> _uiConfigFuture;

  @override
  void initState() {
    super.initState();
    _uiConfigFuture = ConfigService.loadUIConfig();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _uiConfigFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Scaffold(
            body: Center(
              child: Text('Error loading settings screen: ${snapshot.error}'),
            ),
          );
        }

        final uiConfig = snapshot.data!;
        final settingsScreenConfig = uiConfig['settings_screen'];

        if (settingsScreenConfig == null) {
          return const Scaffold(
            body: Center(
              child: Text('Settings screen configuration not found'),
            ),
          );
        }

        return DynamicUIFactory.buildWidget(settingsScreenConfig, context);
      },
    );
  }
}
