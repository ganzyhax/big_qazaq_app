part of 'course_bloc.dart';

@immutable
sealed class CourseState {}

final class CourseInitial extends CourseState {}

class CourseLoaded extends CourseState {
  var data;
  CourseLoaded({required this.data});
}
