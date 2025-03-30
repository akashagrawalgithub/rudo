import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rudo/core/models/auth_models.dart';
import 'package:rudo/core/services/config_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ConfigService', () {
    setUp(() {
      // Setup asset bundle for testing
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(const MethodChannel('flutter/assets'), (
            MethodCall methodCall,
          ) async {
            if (methodCall.method == 'getAssetBundlePath') {
              return '';
            }
            return null;
          });
    });

    test(
      'loadAuthConfig returns default config when asset loading fails',
      () async {
        // Mock asset bundle to return error
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(const MethodChannel('flutter/assets'), (
              MethodCall methodCall,
            ) async {
              if (methodCall.method == 'Flutter.loadAsset') {
                throw Exception('Asset not found');
              }
              return null;
            });

        // Act
        final config = await ConfigService.loadAuthConfig();

        // Assert
        expect(config.enabledMethods, [AuthMethod.email, AuthMethod.google]);
        expect(config.welcomeText, 'Welcome');
        expect(config.loginButtonText, 'Login');
        expect(config.registerButtonText, 'Register');
      },
    );

    test('loadUIConfig returns empty map when asset loading fails', () async {
      // Mock asset bundle to return error
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(const MethodChannel('flutter/assets'), (
            MethodCall methodCall,
          ) async {
            if (methodCall.method == 'Flutter.loadAsset') {
              throw Exception('Asset not found');
            }
            return null;
          });

      // Act
      final config = await ConfigService.loadUIConfig();

      // Assert
      expect(config, {});
    });
  });
}
