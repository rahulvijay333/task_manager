part of 'delete_bloc.dart';

class DeleteEvent {}


class DeleteNoteEvent extends DeleteEvent {

  final String id;
  final String userID;

  DeleteNoteEvent({required this.id, required this.userID});

  
}


