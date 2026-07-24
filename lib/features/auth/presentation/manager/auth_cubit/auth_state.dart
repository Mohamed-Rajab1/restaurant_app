part of 'auth_cubit.dart';

abstract class AuthState {}

final class AuthInitialState extends AuthState {}

final class AuthLoadingState extends AuthState {}

final class AuthSuccessState extends AuthState {
  final UserEntity user;

  AuthSuccessState(this.user);
}

final class AuthFailureState extends AuthState {
  final String error;

  AuthFailureState(this.error);
}
