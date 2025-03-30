import 'package:flutter/material.dart';
import 'package:rudo/core/services/config_service.dart';
import 'package:rudo/ui/components/dynamic_ui_factory.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
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
              child: Text('Error loading dashboard: ${snapshot.error}'),
            ),
          );
        }

        final uiConfig = snapshot.data!;
        final dashboardConfig = uiConfig['dashboard'];
        final List<dynamic> menuItems = dashboardConfig['menu'] ?? [];

        final List<Widget> screens = _buildScreens(uiConfig, menuItems);

        return Scaffold(
          backgroundColor: Colors.white,
          body:
              screens.isNotEmpty
                  ? screens[_currentIndex]
                  : const Center(child: Text('No screens configured')),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            items:
                menuItems.map<BottomNavigationBarItem>((item) {
                  return BottomNavigationBarItem(
                    icon: Icon(DynamicUIFactory.parseIconData(item['icon'])),
                    label: item['title'] ?? '',
                  );
                }).toList(),
            selectedItemColor: Theme.of(context).primaryColor,
            backgroundColor: Colors.white,
            elevation: 8,
            unselectedItemColor: Colors.grey,
          ),
        );
      },
    );
  }

  List<Widget> _buildScreens(
    Map<String, dynamic> config,
    List<dynamic> menuItems,
  ) {
    return menuItems.map<Widget>((item) {
      final String screenKey = item['screen'] ?? '';
      if (config.containsKey(screenKey)) {
        return DynamicUIFactory.buildWidget(config[screenKey], context);
      }
      return const Center(child: Text('Screen not found'));
    }).toList();
  }
}
