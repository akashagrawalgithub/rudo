import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rudo/ui/components/dynamic_ui_factory.dart';

void main() {
  group('DynamicUIFactory', () {
    testWidgets('builds text widget correctly', (WidgetTester tester) async {
      // Arrange
      final json = {
        'type': 'text',
        'text': 'Hello World',
        'style': {'fontSize': 20.0, 'fontWeight': 'bold', 'color': '#FF0000'},
      };

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DynamicUIFactory.buildWidget(
              json as Map<String, dynamic>,
              tester.element(find.byType(MaterialApp)),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Hello World'), findsOneWidget);
      final textWidget = tester.widget<Text>(find.text('Hello World'));
      expect(textWidget.style?.fontSize, 20.0);
      expect(textWidget.style?.fontWeight, FontWeight.bold);
      expect(textWidget.style?.color, const Color(0xFFFF0000));
    });

    testWidgets('builds button widget correctly', (WidgetTester tester) async {
      // Arrange
      final json = {'type': 'button', 'text': 'Click Me', 'style': 'elevated'};

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DynamicUIFactory.buildWidget(
              json,
              tester.element(find.byType(MaterialApp)),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Click Me'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('builds container with child correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      final json = {
        'type': 'container',
        'padding': 16.0,
        'color': '#EEEEEE',
        'child': {'type': 'text', 'text': 'Container Child'},
      };

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DynamicUIFactory.buildWidget(
              json,
              tester.element(find.byType(MaterialApp)),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Container Child'), findsOneWidget);
      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.padding, const EdgeInsets.all(16.0));
      expect(container.color, const Color(0xFFEEEEEE));
    });

    testWidgets('builds column with children correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      final json = {
        'type': 'column',
        'children': [
          {'type': 'text', 'text': 'Item 1'},
          {'type': 'text', 'text': 'Item 2'},
        ],
      };

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DynamicUIFactory.buildWidget(
              json,
              tester.element(find.byType(MaterialApp)),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
    });

    testWidgets('returns empty widget for empty JSON', (
      WidgetTester tester,
    ) async {
      // Arrange
      final json = {};

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DynamicUIFactory.buildWidget(
              json as Map<String, dynamic>,
              tester.element(find.byType(MaterialApp)),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(SizedBox), findsOneWidget);
      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.width, 0.0);
      expect(sizedBox.height, 0.0);
    });
  });
}
