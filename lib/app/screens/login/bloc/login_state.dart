part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoaded extends LoginState {}

final class LoginSuccess extends LoginState {}

final class LoginError extends LoginState {}

final class LoginVerify extends LoginState {
  String userId;
  String userPhone;
  String pin;
  LoginVerify(
      {required this.userId, required this.userPhone, required this.pin});
}
