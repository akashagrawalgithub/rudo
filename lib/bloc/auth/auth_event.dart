import 'package:equatable/equatable.dart';
import 'package:rudo/core/models/auth_models.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AppStarted extends AuthEvent {}

class LoggedIn extends AuthEvent {
  final User user;

  const LoggedIn({required this.user});

  @override
  List<Object?> get props => [user];
}

class LoggedOut extends AuthEvent {}

class SignInWithEmailPasswordRequested extends AuthEvent {
  final String email;
  final String password;

  const SignInWithEmailPasswordRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class SignInWithGoogleRequested extends AuthEvent {}

class SignInWithAppleRequested extends AuthEvent {}

class PhoneVerificationRequested extends AuthEvent {
  final String phoneNumber;

  const PhoneVerificationRequested({required this.phoneNumber});

  @override
  List<Object?> get props => [phoneNumber];
}

class OtpVerificationRequested extends AuthEvent {
  final String verificationId;
  final String smsCode;

  const OtpVerificationRequested({
    required this.verificationId,
    required this.smsCode,
  });

  @override
  List<Object?> get props => [verificationId, smsCode];
}

class RegisterWithEmailPasswordRequested extends AuthEvent {
  final String email;
  final String password;

  const RegisterWithEmailPasswordRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}
