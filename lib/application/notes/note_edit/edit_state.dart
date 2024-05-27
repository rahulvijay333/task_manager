part of 'edit_bloc.dart';

class EditState {}

class EditInitial extends EditState {}

class EditnoteLoading extends EditState {}

class EditNoteSuccess extends EditState {}

class EditNoteFailed extends EditState {

  final String errorMessage;

  EditNoteFailed({required this.errorMessage});
}
