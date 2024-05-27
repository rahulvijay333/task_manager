part of 'auth_bloc.dart';

class AuthState {}

class AuthInitial extends AuthState {}

class AuthSuccess extends AuthState {
  final String userId;

  AuthSuccess({required this.userId});

  
}

class AuthFailed extends AuthState {}
