part of 'register_bloc.dart';

class RegisterEvent {}

class RegisterNewUser extends RegisterEvent {
  final String email;
  final String password;

  final String fullname;

  RegisterNewUser(
      {required this.email, required this.password, required this.fullname});
}
