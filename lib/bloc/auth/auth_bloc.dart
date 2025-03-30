import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rudo/bloc/auth/auth_event.dart';
import 'package:rudo/bloc/auth/auth_state.dart';
import 'package:rudo/core/repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);
    on<SignInWithEmailPasswordRequested>(_onSignInWithEmailPasswordRequested);
    on<SignInWithGoogleRequested>(_onSignInWithGoogleRequested);
    on<SignInWithAppleRequested>(_onSignInWithAppleRequested);
    on<PhoneVerificationRequested>(_onPhoneVerificationRequested);
    on<OtpVerificationRequested>(_onOtpVerificationRequested);
    on<RegisterWithEmailPasswordRequested>(
      _onRegisterWithEmailPasswordRequested,
    );
  }

  void _onAppStarted(AppStarted event, Emitter<AuthState> emit) {
    final currentUser = _authRepository.currentUser;
    if (currentUser != null) {
      emit(Authenticated(currentUser));
    } else {
      emit(Unauthenticated());
    }
  }

  void _onLoggedIn(LoggedIn event, Emitter<AuthState> emit) {
    final currentUser = _authRepository.currentUser;
    if (currentUser != null) {
      emit(Authenticated(currentUser));
    }
  }

  Future<void> _onLoggedOut(LoggedOut event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepository.signOut();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignInWithEmailPasswordRequested(
    SignInWithEmailPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signInWithEmailAndPassword(
        event.email,
        event.password,
      );
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(const AuthError('Failed to sign in'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignInWithGoogleRequested(
    SignInWithGoogleRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signInWithGoogle();
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(const AuthError('Failed to sign in with Google'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignInWithAppleRequested(
    SignInWithAppleRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signInWithApple();
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(const AuthError('Failed to sign in with Apple'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onPhoneVerificationRequested(
    PhoneVerificationRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.verifyPhoneNumber(
        phoneNumber: event.phoneNumber,
        onCodeSent: (verificationId, resendToken) {
          emit(
            PhoneVerificationInProgress(
              verificationId: verificationId,
              resendToken: resendToken,
            ),
          );
        },
        onError: (errorMessage) {
          emit(AuthError(errorMessage));
        },
      );
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onOtpVerificationRequested(
    OtpVerificationRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.verifyOTP(
        verificationId: event.verificationId,
        smsCode: event.smsCode,
      );
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(const AuthError('Failed to verify OTP'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onRegisterWithEmailPasswordRequested(
    RegisterWithEmailPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.registerWithEmailAndPassword(
        event.email,
        event.password,
      );
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(const AuthError('Failed to register'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
