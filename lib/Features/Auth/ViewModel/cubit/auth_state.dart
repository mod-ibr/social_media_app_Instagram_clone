part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class LoadingAuthState extends AuthState {}

class SucceededAuthState extends AuthState {}

class ErrorAuthState extends AuthState {
  final String message;

  const ErrorAuthState({required this.message});
  @override
  List<Object> get props => [message];
}

class ShowPasswordState extends AuthState {
  final bool isPasswordVisible;
  const ShowPasswordState({required this.isPasswordVisible});
  @override
  List<Object> get props => [isPasswordVisible];
}

class HidePasswordState extends AuthState {
  final bool isPasswordVisible;
  const HidePasswordState({required this.isPasswordVisible});
  @override
  List<Object> get props => [isPasswordVisible];
}

class LoggedInState extends AuthState {}

class NotLoggedInState extends AuthState {}
