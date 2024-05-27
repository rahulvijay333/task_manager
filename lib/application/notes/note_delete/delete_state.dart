part of 'delete_bloc.dart';

 class DeleteState {}

 class DeleteInitial extends DeleteState {}


class DeletenoteLoading extends DeleteState {}

class DeleteNoteSuccess extends DeleteState {}

class DeleteNoteFailed extends DeleteState {

  final String errorMessage;

  DeleteNoteFailed({required this.errorMessage});
}
