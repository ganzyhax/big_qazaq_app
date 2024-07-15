import 'package:big_qazaq_app/api/api.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    List courses = [];
    List banners = [];
    var userCourses = [];
    DocumentSnapshot<Map<String, dynamic>> userData;
    on<HomeEvent>((event, emit) async {
      // TODO: implement event handler
      if (event is HomeLoad) {
        userCourses = [];
        courses = await ApiClient().getAllDocuments('courses');
        banners = await ApiClient().getAllDocuments('banners');

        SharedPreferences prefs = await SharedPreferences.getInstance();
        userData = await ApiClient()
            .getDocumentById('users', await prefs.getString('userId') ?? '');
        var userCourseIds = Set.from(
            userData['courses']); // Convert list to set for fast lookup

        for (var course in courses) {
          if (userCourseIds.contains(course['id'])) {
            userCourses.add(course);
          }
        }
        emit(HomeLoaded(
            userCourses: userCourses,
            courses: courses,
            userData: userData,
            banners: banners));
      }
    });
  }
}
