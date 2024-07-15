part of 'reset_bloc.dart';

@immutable
sealed class ResetEvent {}

final class ResetLoad extends ResetEvent {}

final class ResetSendOTP extends ResetEvent {
  final String phone;
  ResetSendOTP({required this.phone});
}

final class ResetCheckOTP extends ResetEvent {
  final String otp;
  ResetCheckOTP({required this.otp});
}
