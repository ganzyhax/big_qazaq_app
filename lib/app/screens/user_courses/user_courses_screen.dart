import 'package:big_qazaq_app/app/data/const/app_colors.dart';
import 'package:big_qazaq_app/app/screens/home/bloc/home_bloc.dart';
import 'package:big_qazaq_app/app/screens/home/components/course_card.dart';
import 'package:big_qazaq_app/app/screens/home/components/pages/detail/course_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCoursesScreen extends StatelessWidget {
  const UserCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kSecondartBackgroundColor,
        title: Center(
          child: Text(
            'Курстар',
            style: TextStyle(
                color: Colors.black, fontSize: 17, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoaded) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.courses.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: InkWell(
                              onTap: () {
                                if (state.userData['courses']
                                    .contains(state.courses[index]['id'])) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CourseModulesPage(
                                              data: state.courses[index],
                                              title: state.courses[index]
                                                  ['name'],
                                            )),
                                  );
                                } else {
                                  const snackBar = SnackBar(
                                    content: Text(
                                        'Курсты ашу үшін ватсапқа жазыңыз!'),
                                  );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              },
                              child: Stack(children: [
                                CourseCard(data: state.courses[index]),
                                (!state.userData['courses']
                                        .contains(state.courses[index]['id']))
                                    ? Positioned(
                                        right: 5,
                                        child: Icon(
                                          Icons.lock,
                                          color: Colors.grey[400],
                                        ))
                                    : SizedBox()
                              ])),
                        );
                      })
                ],
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
