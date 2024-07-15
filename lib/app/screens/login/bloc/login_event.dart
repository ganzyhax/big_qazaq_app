part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

final class LoginLoad extends LoginEvent {}

final class LoginLog extends LoginEvent {
  String phone;
  String pass;
  LoginLog({required this.pass, required this.phone});
}
