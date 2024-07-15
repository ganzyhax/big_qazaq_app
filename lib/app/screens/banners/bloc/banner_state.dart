part of 'banner_bloc.dart';

@immutable
sealed class BannerState {}

final class BannerInitial extends BannerState {}

final class BannerLoaded extends BannerState {
  List banners;
  BannerLoaded({required this.banners});
}
