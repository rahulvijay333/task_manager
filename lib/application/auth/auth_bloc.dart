import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        //logged in
        log('user is logged');
        emit(AuthSuccess(userId: currentUser.uid));
        // UserModel? thisusermodel =
        //     await FirebaseHelper.getUserModelById(currentUser.uid);

        // runApp(ChatAppLoggedIn(user: thisusermodel!, firebaseUser: currentUser));
      } else {
        // runApp(const ChatApp());
        emit(AuthFailed());
        log('user is not logged');
      }
    });
  }
}
