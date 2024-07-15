part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoaded extends HomeState {
  final userCourses;
  final userData;
  final banners;
  final courses;
  HomeLoaded(
      {required this.userCourses,
      required this.courses,
      required this.userData,
      required this.banners});
}
