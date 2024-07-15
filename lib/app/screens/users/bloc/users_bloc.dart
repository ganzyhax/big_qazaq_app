import 'dart:developer';

import 'package:big_qazaq_app/api/api.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  UsersBloc() : super(UsersInitial()) {
    List data = [];
    List courses = [];
    List sortedList = [];
    String searchText = '';
    on<UsersEvent>((event, emit) async {
      if (event is UsersLoad) {
        data = await ApiClient().getAllDocuments('users');
        courses = await ApiClient().getAllDocuments('courses');
        for (var i = 0; i < data.length; i++) {
          data[i]['coursesData'] = [];
          for (var c = 0; c < courses.length; c++) {
            for (var u = 0; u < data[i]['courses'].length; u++) {
              if (data[i]['courses'][u] == courses[c]['id']) {
                data[i]['coursesData'].add(courses[c]);
              }
            }
          }
        }
        for (var i = 0; i < data.length; i++) {
          for (var s = 0; s < data[i]['coursesData'].length; s++) {
            print(data[i]['coursesData'].length);
          }
        }
        emit(UsersLoaded(data: data, courses: courses));
      }
      if (event is UsersSearch) {
        searchText = event.searchText;
        if (searchText == '') {
          emit(UsersLoaded(data: data, courses: courses));
        } else {
          sortedList =
              data.where((user) => user['phone'].contains(searchText)).toList();
          emit(UsersLoaded(data: sortedList, courses: courses));
        }
      }
      if (event is UsersDelete) {
        await ApiClient().deleteDocument('users', event.userId);
        add(UsersLoad());
      }
    });
  }
}
