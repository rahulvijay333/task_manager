part of 'register_bloc.dart';

class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {}

class RegisterFailed extends RegisterState {
  final String showErrorMessage ;

  RegisterFailed({required this.showErrorMessage});
}
