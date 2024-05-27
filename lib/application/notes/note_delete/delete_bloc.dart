import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_rv/Infrastructure/db/db_service.dart';
import 'package:task_manager_rv/core/common/connectivity.dart';

part 'delete_event.dart';
part 'delete_state.dart';

class DeleteBloc extends Bloc<DeleteEvent, DeleteState> {
  final FirebaseDbService firebaseDbService;
  final ConnectivityService connectivityService;
  DeleteBloc(this.firebaseDbService, this.connectivityService)
      : super(DeleteInitial()) {
    on<DeleteNoteEvent>((event, emit) async {
      emit(DeletenoteLoading());

      final connectionStatus =
          await connectivityService.checkIntilialConnection();

      if (connectionStatus) {
        final deleteStatus = await firebaseDbService.deleteNote(id: event.id,userid: event.userID);

        if (deleteStatus.$1) {
          emit(DeleteNoteSuccess());
        } else {
          emit(DeleteNoteFailed(
              errorMessage:
                  deleteStatus.$2 ?? 'Server Offline, please try lator'));
        }
      } else {
        emit(DeleteNoteFailed(errorMessage: 'Check Internet connection'));
      }
    });
  }
}
