import 'package:big_qazaq_app/app/screens/banners/bloc/banner_bloc.dart';
import 'package:big_qazaq_app/app/screens/course/bloc/course_bloc.dart';
import 'package:big_qazaq_app/app/screens/create/bloc/create_bloc.dart';
import 'package:big_qazaq_app/app/screens/home/bloc/home_bloc.dart';
import 'package:big_qazaq_app/app/screens/login/bloc/login_bloc.dart';
import 'package:big_qazaq_app/app/screens/login/login_screen.dart';
import 'package:big_qazaq_app/app/screens/navigator/bloc/main_navigator_bloc.dart';
import 'package:big_qazaq_app/app/screens/navigator/main_navigator.dart';
import 'package:big_qazaq_app/app/screens/reset/bloc/reset_bloc.dart';
import 'package:big_qazaq_app/app/screens/splash/splash_screen.dart';
import 'package:big_qazaq_app/app/screens/users/bloc/users_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BigQazaqApp extends StatelessWidget {
  const BigQazaqApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => MainNavigatorBloc()..add(MainNavigatorLoad()),
          ),
          BlocProvider(
            create: (context) => LoginBloc()..add(LoginLoad()),
          ),
          BlocProvider(
            create: (context) => CourseBloc()..add(CourseLoad()),
          ),
          BlocProvider(
            create: (context) => UsersBloc()..add(UsersLoad()),
          ),
          BlocProvider(
            create: (context) => HomeBloc()..add(HomeLoad()),
          ),
          BlocProvider(
            create: (context) => CreateBloc()..add(CreateLoad()),
          ),
          BlocProvider(
            create: (context) => BannerBloc()..add(BannerLoad()),
          ),
          BlocProvider(
            create: (context) => ResetBloc()..add(ResetLoad()),
          ),
        ],
        child: MaterialApp(
          builder: (BuildContext context, Widget? child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaleFactor: 1.0,
              ),
              child: child!,
            );
          },
          debugShowCheckedModeBanner: false,
          title: 'Big Qazaq App',
          home: SplashScreen(),
        ));
  }
}
