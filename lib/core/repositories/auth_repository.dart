import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:rudo/core/models/auth_models.dart';
import 'package:rudo/core/services/auth_service.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository({required AuthService authService})
    : _authService = authService;

  User? get currentUser => _authService.currentUser;

  Stream<User?> get authStateChanges => _authService.authStateChanges;

  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return await _authService.signInWithEmailAndPassword(email, password);
  }

  Future<User?> signInWithGoogle() async {
    return await _authService.signInWithGoogle();
  }

  Future<User?> signInWithApple() async {
    return await _authService.signInWithApple();
  }

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String verificationId, int? resendToken) onCodeSent,
    required Function(String errorMessage) onError,
  }) async {
    await _authService.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (
        firebase_auth.PhoneAuthCredential credential,
      ) async {
        // Auto-verification completed (Android only)
        try {
          await _authService.verifyOTP(
            verificationId: credential.verificationId ?? '',
            smsCode: credential.smsCode ?? '',
          );
        } catch (e) {
          onError(e.toString());
        }
      },
      verificationFailed: (firebase_auth.FirebaseAuthException e) {
        onError(e.message ?? 'Verification failed');
      },
      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId, resendToken);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-retrieval timeout
      },
    );
  }

  Future<User?> verifyOTP({
    required String verificationId,
    required String smsCode,
  }) async {
    return await _authService.verifyOTP(
      verificationId: verificationId,
      smsCode: smsCode,
    );
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  Future<User?> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return await _authService.registerWithEmailAndPassword(email, password);
  }
}
