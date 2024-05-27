import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_rv/Infrastructure/auth/auth_service.dart';
import 'package:task_manager_rv/core/common/connectivity.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final FirebaseAuthService firebaseAuthService;
  final ConnectivityService connectivityService;
  RegisterBloc(this.firebaseAuthService, this.connectivityService)
      : super(RegisterInitial()) {
    on<RegisterNewUser>((event, emit) async {

      //----------------------------------show loading indicator in ui
      emit(RegisterLoading());

      final connectionStatus =
          await connectivityService.checkIntilialConnection();

      if (connectionStatus) {
        final regisStatus = await firebaseAuthService.register(
            email: event.email,
            password: event.password,
            fullname: event.fullname);

        if (regisStatus.isEmpty) {
          //----------------------------------------if registration is success goes to back to login page
          emit(RegisterSuccess());
        } else {
          //------------------------------------------other wise shows error 
          emit(RegisterFailed(showErrorMessage: regisStatus));
        }
      } else {
        emit(RegisterFailed(showErrorMessage: 'check internet connection'));
      }
    });
  }
}
