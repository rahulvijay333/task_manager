import 'dart:developer';


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_rv/Infrastructure/auth/auth_service.dart';
import 'package:task_manager_rv/domain/user_model.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final FirebaseAuthService firebaseAuthService;

  LoginBloc(this.firebaseAuthService) : super(LoginInitial()) {
    on<LoginUsingEmail>((event, emit) async {
      emit(LoginLoading());
      //-----------------------------------------calls firebase email signin api
      //-----------------------------------------expects two values an error and userdata
      final login = await firebaseAuthService.login(
          email: event.username, password: event.password);

      if (login.$1 == null) {
        log('sucess');
        emit(LoginSuccess(userData: login.$2!));
      } else {
        log('login failed');
        emit(LoginFailure(showError: login.$1!));
      }
    });
  }
}
