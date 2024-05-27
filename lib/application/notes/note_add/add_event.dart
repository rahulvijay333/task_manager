part of 'add_bloc.dart';

class AddEvent {}

class AddNoteEevent extends AddEvent {
  final TaskModel task;
  final String userID;

  AddNoteEevent({required this.task, required this.userID});

  
}
