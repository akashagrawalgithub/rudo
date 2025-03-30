import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:rudo/core/services/auth_service.dart';

import 'auth_service_test.mocks.dart';

@GenerateMocks([FirebaseAuth, UserCredential, User])
void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late AuthService authService;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    authService = AuthService(firebaseAuth: mockFirebaseAuth);
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();

    when(mockUserCredential.user).thenReturn(mockUser);
    when(mockUser.uid).thenReturn('test-uid');
    when(mockUser.email).thenReturn('test@example.com');
    when(mockUser.displayName).thenReturn('Test User');
  });

  group('AuthService', () {
    test('signInWithEmailAndPassword returns user when successful', () async {
      // Arrange
      when(
        mockFirebaseAuth.signInWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password123',
        ),
      ).thenAnswer((_) async => mockUserCredential);

      // Act
      final result = await authService.signInWithEmailAndPassword(
        'test@example.com',
        'password123',
      );

      // Assert
      expect(result, isNotNull);
      expect(result!.uid, 'test-uid');
      expect(result.email, 'test@example.com');
      verify(
        mockFirebaseAuth.signInWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password123',
        ),
      ).called(1);
    });

    test('signInWithEmailAndPassword returns null when error occurs', () async {
      // Arrange
      when(
        mockFirebaseAuth.signInWithEmailAndPassword(
          email: 'test@example.com',
          password: 'wrong-password',
        ),
      ).thenThrow(FirebaseAuthException(code: 'wrong-password'));

      // Act
      final result = await authService.signInWithEmailAndPassword(
        'test@example.com',
        'wrong-password',
      );

      // Assert
      expect(result, isNull);
    });

    test(
      'createUserWithEmailAndPassword returns user when successful',
      () async {
        // Arrange
        when(
          mockFirebaseAuth.createUserWithEmailAndPassword(
            email: 'new@example.com',
            password: 'password123',
          ),
        ).thenAnswer((_) async => mockUserCredential);

        // Act
        final result = await authService.registerWithEmailAndPassword(
          'new@example.com',
          'password123',
        );

        // Assert
        expect(result, isNotNull);
        expect(result!.uid, 'test-uid');
        verify(
          mockFirebaseAuth.createUserWithEmailAndPassword(
            email: 'new@example.com',
            password: 'password123',
          ),
        ).called(1);
      },
    );

    test('signOut calls Firebase signOut', () async {
      // Arrange
      when(mockFirebaseAuth.signOut()).thenAnswer((_) async => null);

      // Act
      await authService.signOut();

      // Assert
      verify(mockFirebaseAuth.signOut()).called(1);
    });

    test('getCurrentUser returns current user when signed in', () async {
      // Arrange
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

      // Act
      final result = await authService.currentUser;

      // Assert
      expect(result, isNotNull);
      expect(result!.uid, 'test-uid');
      expect(result.email, 'test@example.com');
    });

    test('getCurrentUser returns null when not signed in', () async {
      // Arrange
      when(mockFirebaseAuth.currentUser).thenReturn(null);

      // Act
      final result = await authService.currentUser;

      // Assert
      expect(result, isNull);
    });
  });
}
