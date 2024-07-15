import 'package:big_qazaq_app/api/api.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'course_event.dart';
part 'course_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  CourseBloc() : super(CourseInitial()) {
    List data = [];
    on<CourseEvent>((event, emit) async {
      if (event is CourseLoad) {
        data = await ApiClient().getAllDocuments('courses');

        emit(CourseLoaded(data: data));
      }
      if (event is CourseDelete) {
        await ApiClient().deleteDocument('courses', event.id);
        add(CourseLoad());
      }
    });
  }
}
