part of 'login_bloc.dart';

class LoginEvent {}

class LoginUsingEmail extends LoginEvent {
  final String username;
  final String password;

  LoginUsingEmail({required this.username, required this.password});
}

class Logout extends LoginEvent {}
