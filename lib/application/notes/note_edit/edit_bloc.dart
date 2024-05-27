import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_rv/Infrastructure/db/db_service.dart';
import 'package:task_manager_rv/core/common/connectivity.dart';
import 'package:task_manager_rv/domain/task_model.dart';

part 'edit_event.dart';
part 'edit_state.dart';

class EditBloc extends Bloc<EditEvent, EditState> {
  final FirebaseDbService firebaseDbService;
  final ConnectivityService connectivityService;
  EditBloc(this.firebaseDbService, this.connectivityService)
      : super(EditInitial()) {
    on<EditNoteEvent>((event, emit) async {
      emit(EditnoteLoading());

      final connectionStatus =
          await connectivityService.checkIntilialConnection();

      if (connectionStatus) {
        final editStatus = await firebaseDbService.editNote(task: event.task, userid: event.userID);

        if (editStatus.$1) {
          emit(EditNoteSuccess());
        } else {
          emit(EditNoteFailed(
              errorMessage:
                  editStatus.$2 ?? 'Server offline, Please try lator'));
        }
      } else {
        emit(EditNoteFailed(errorMessage: 'check internet connection'));
      }
    });
  }
}
