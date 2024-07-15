part of 'users_bloc.dart';

@immutable
sealed class UsersState {}

final class UsersInitial extends UsersState {}

final class UsersLoaded extends UsersState {
  final data;
  final courses;
  UsersLoaded({required this.data, required this.courses});
}
