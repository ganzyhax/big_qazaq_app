part of 'users_bloc.dart';

@immutable
sealed class UsersEvent {}

final class UsersLoad extends UsersEvent {}

final class UsersSearch extends UsersEvent {
  String searchText;
  UsersSearch({required this.searchText});
}

final class UsersDelete extends UsersEvent {
  final String userId;
  UsersDelete({required this.userId});
}
