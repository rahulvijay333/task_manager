part of 'login_bloc.dart';

class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {

  final UserModel userData;

  LoginSuccess({required this.userData});
}

class LoginFailure extends LoginState {
  final String showError;

  LoginFailure({required this.showError});
}
