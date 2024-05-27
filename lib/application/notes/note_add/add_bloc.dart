import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_rv/Infrastructure/db/db_service.dart';
import 'package:task_manager_rv/core/common/connectivity.dart';
import 'package:task_manager_rv/core/notifications/notifications.dart';
import 'package:task_manager_rv/domain/task_model.dart';

part 'add_event.dart';
part 'add_state.dart';

class AddBloc extends Bloc<AddEvent, AddState> {
  final FirebaseDbService firebaseDbService;
  final ConnectivityService connectivityService;

  AddBloc(this.firebaseDbService, this.connectivityService)
      : super(AddInitial()) {
    on<AddNoteEevent>((event, emit) async {
      emit(AddnoteLoading());

      final connectionStatus =
          await connectivityService.checkIntilialConnection();

      if (connectionStatus) {
        final addStatus = await firebaseDbService.addNote(
            task: event.task, userid: event.userID);

        if (addStatus.$1) {
        
          emit(AddNoteSuccess());

            //---------------------------------------------------------------set notificationis
          NotificationService().scheduleNotification(
              id: int.parse(
                event.task.id,
              ),
              title: 'task reminder',
              body: event.task.title,
              scheduledNotificationDateTime: event.task.dueDateTime);
        } else {
          emit(AddNoteFailed(
              errorMessage: addStatus.$2 ?? 'Note creation failed '));
        }
      } else {
        emit(AddNoteFailed(errorMessage: 'Check Internet connection'));
      }
    });
  }
}
