import 'package:flutter/material.dart';
import 'package:rudo/core/services/config_service.dart';
import 'package:rudo/ui/components/dynamic_ui_factory.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late Future<Map<String, dynamic>> _uiConfigFuture;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _uiConfigFuture = ConfigService.loadUIConfig();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
              child: Text('Error loading search screen: ${snapshot.error}'),
            ),
          );
        }

        final uiConfig = snapshot.data!;
        final searchScreenConfig = uiConfig['search_screen'];

        if (searchScreenConfig == null) {
          return const Scaffold(
            body: Center(child: Text('Search screen configuration not found')),
          );
        }

        // Inject the search controller into the context for dynamic UI to use
        return _SearchControllerProvider(
          controller: _searchController,
          child: DynamicUIFactory.buildWidget(searchScreenConfig, context),
        );
      },
    );
  }
}

// Provider widget to make the search controller available to the dynamic UI
class _SearchControllerProvider extends InheritedWidget {
  final TextEditingController controller;

  const _SearchControllerProvider({
    required this.controller,
    required Widget child,
    Key? key,
  }) : super(key: key, child: child);

  static _SearchControllerProvider? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_SearchControllerProvider>();
  }

  @override
  bool updateShouldNotify(_SearchControllerProvider oldWidget) {
    return controller != oldWidget.controller;
  }
}
