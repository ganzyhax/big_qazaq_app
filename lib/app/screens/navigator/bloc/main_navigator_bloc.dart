import 'package:big_qazaq_app/app/screens/banners/banner_screen.dart';
import 'package:big_qazaq_app/app/screens/course/course_screen.dart';
import 'package:big_qazaq_app/app/screens/home/home_screen.dart';
import 'package:big_qazaq_app/app/screens/profile/profile_screen.dart';
import 'package:big_qazaq_app/app/screens/user_courses/user_courses_screen.dart';
import 'package:big_qazaq_app/app/screens/users/users_screen.dart';
import 'package:bloc/bloc.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'main_navigator_event.dart';
part 'main_navigator_state.dart';

class MainNavigatorBloc extends Bloc<MainNavigatorEvent, MainNavigatorState> {
  MainNavigatorBloc() : super(MainNavigatorInitial()) {
    List screens = [
      HomeScreen(),
      UserCoursesScreen(),
      ProfileScreen(),
    ];
    int index = 0;
    bool isAdmin = false;
    on<MainNavigatorEvent>((event, emit) async {
      if (event is MainNavigatorLoad) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        isAdmin = await prefs.getBool('isAdmin') ?? false;
        print(isAdmin);
        if (isAdmin) {
          screens = [CoursesScreen(), UsersScreen(), BannerScreen()];
        }
        emit(MainNavigatorLoaded(
            index: index, screens: screens, isAdmin: isAdmin));
      }

      if (event is MainNavigatorChangePage) {
        index = event.index;
        emit(MainNavigatorLoaded(
            index: index, screens: screens, isAdmin: isAdmin));
      }
      if (event is MainNavigatorClear) {
        emit(MainNavigatorInitial());
      }
    });
  }
}
