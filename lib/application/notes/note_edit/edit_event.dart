part of 'edit_bloc.dart';

class EditEvent {}

class EditNoteEvent extends EditEvent {

  final TaskModel task;
  final String userID;

  EditNoteEvent({required this.task, required this.userID});

 
}


