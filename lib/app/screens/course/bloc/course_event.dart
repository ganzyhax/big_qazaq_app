part of 'course_bloc.dart';

@immutable
sealed class CourseEvent {}

class CourseLoad extends CourseEvent {}

class CourseDelete extends CourseEvent {
  final String id;
  CourseDelete({required this.id});
}
