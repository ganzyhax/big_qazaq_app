part of 'banner_bloc.dart';

@immutable
sealed class BannerEvent {}

final class BannerLoad extends BannerEvent {}

final class BannerAdd extends BannerEvent {
  final String imageUrl;
  BannerAdd({required this.imageUrl});
}

final class BannerDelete extends BannerEvent {
  String id;
  BannerDelete({required this.id});
}
