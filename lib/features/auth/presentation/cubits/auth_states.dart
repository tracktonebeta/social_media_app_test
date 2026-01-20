import 'package:social_media_app_test/features/auth/domain/entities/app_user.dart';

abstract class AuthStates {}

// initial state
class AuthInitial extends AuthStates {}
// loading state
class AuthLoading extends AuthStates {}
// authenticated state
class AuthAuthenticated extends AuthStates {
  final AppUser user;
  AuthAuthenticated({required this.user});
}
// unauthenticated state
class Unauthenticated extends AuthStates {}

// error state
class AuthError extends AuthStates {
  final String error;
  AuthError({required this.error});
}