import 'package:flutter/material.dart';
import 'package:rudo/core/services/config_service.dart';
import 'package:rudo/ui/components/dynamic_ui_factory.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
              child: Text('Error loading home screen: ${snapshot.error}'),
            ),
          );
        }

        final uiConfig = snapshot.data!;
        final homeScreenConfig = uiConfig['home_screen'];

        if (homeScreenConfig == null) {
          return const Scaffold(
            body: Center(child: Text('Home screen configuration not found')),
          );
        }

        return DynamicUIFactory.buildWidget(homeScreenConfig, context);
      },
    );
  }
}
