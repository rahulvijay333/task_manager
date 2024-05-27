part of 'add_bloc.dart';

class AddState {}

class AddInitial extends AddState {}

class AddnoteLoading extends AddState {}

class AddNoteSuccess extends AddState {}

class AddNoteFailed extends AddState {

  final String errorMessage;

  AddNoteFailed({required this.errorMessage});
}
