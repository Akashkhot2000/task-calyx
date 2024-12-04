import 'package:task/models/user_model.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final UserModels userModels;

  UserLoaded(this.userModels);
}

class UserError extends UserState {
  final String message;

  UserError(this.message);
}
