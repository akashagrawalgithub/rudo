import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:rudo/bloc/auth/auth_bloc.dart';
import 'package:rudo/bloc/auth/auth_event.dart';
import 'package:rudo/bloc/auth/auth_state.dart';
import 'package:rudo/core/models/auth_models.dart';
import 'package:rudo/core/repositories/auth_repository.dart';

import 'auth_bloc_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
  });

  group('AuthBloc', () {
    final testUser = User(
      uid: 'test-uid',
      email: 'test@example.com',
      displayName: 'Test User',
    );

    test('initial state is Uninitialized', () {
      // Arrange & Act
      final authBloc = AuthBloc(authRepository: mockAuthRepository);

      // Assert
      expect(authBloc.state, isA<AuthInitial>());
    });

    blocTest<AuthBloc, AuthState>(
      'emits [Unauthenticated] when AppStarted is added and user is not logged in',
      build: () {
        when(mockAuthRepository.currentUser).thenAnswer((_) async => null);
        return AuthBloc(authRepository: mockAuthRepository);
      },
      act: (bloc) => bloc.add(AppStarted()),
      expect: () => [isA<Unauthenticated>()],
      verify: (_) {
        verify(mockAuthRepository.currentUser).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [Authenticated] when AppStarted is added and user is logged in',
      build: () {
        when(mockAuthRepository.currentUser).thenAnswer((_) async => testUser);
        return AuthBloc(authRepository: mockAuthRepository);
      },
      act: (bloc) => bloc.add(AppStarted()),
      expect:
          () => [
            isA<Authenticated>().having(
              (state) => state.user.uid,
              'uid',
              'test-uid',
            ),
          ],
      verify: (_) {
        verify(mockAuthRepository.currentUser).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [Loading, Authenticated] when LoggedIn is added',
      build: () {
        return AuthBloc(authRepository: mockAuthRepository);
      },
      act: (bloc) => bloc.add(LoggedIn(user: testUser)),
      expect:
          () => [
            isA<AuthLoading>(),
            isA<Authenticated>().having(
              (state) => state.user.uid,
              'uid',
              'test-uid',
            ),
          ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [Loading, Unauthenticated] when LoggedOut is added',
      build: () {
        when(mockAuthRepository.signOut()).thenAnswer((_) async => null);
        return AuthBloc(authRepository: mockAuthRepository);
      },
      act: (bloc) => bloc.add(LoggedOut()),
      expect: () => [isA<AuthLoading>(), isA<Unauthenticated>()],
      verify: (_) {
        verify(mockAuthRepository.signOut()).called(1);
      },
    );
  });
}
