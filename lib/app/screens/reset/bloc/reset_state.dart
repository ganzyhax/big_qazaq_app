part of 'reset_bloc.dart';

@immutable
sealed class ResetState {}

final class ResetInitial extends ResetState {}

final class ResetSendedOTP extends ResetState {
  final String userId;
  final String userPhone;
  final String pin;
  ResetSendedOTP(
      {required this.userId, required this.pin, required this.userPhone});
}

final class ResetError extends ResetState {
  final String message;
  ResetError({required this.message});
}
