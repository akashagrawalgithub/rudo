import 'package:equatable/equatable.dart';
import 'package:rudo/core/models/auth_models.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final User user;

  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class PhoneVerificationInProgress extends AuthState {
  final String verificationId;
  final int? resendToken;

  const PhoneVerificationInProgress({
    required this.verificationId,
    this.resendToken,
  });

  @override
  List<Object?> get props => [verificationId, resendToken];
}
