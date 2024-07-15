import 'package:big_qazaq_app/app/data/const/app_colors.dart';
import 'package:big_qazaq_app/app/screens/course/bloc/course_bloc.dart';
import 'package:big_qazaq_app/app/screens/create/bloc/create_bloc.dart';
import 'package:big_qazaq_app/app/screens/create/create_screen.dart';
import 'package:big_qazaq_app/app/screens/home/components/course_card.dart';
import 'package:big_qazaq_app/app/screens/home/components/pages/detail/course_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kSecondartBackgroundColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 50,
            ),
            Text(
              'Курстар',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
            GestureDetector(
              onTap: () {
                BlocProvider.of<CreateBloc>(context)..add(CreateLoad());
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateCourseScreen(
                            title: 'Жаңа курс ашу',
                          )),
                );
              },
              child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.black),
                  child: Icon(Icons.add)),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<CourseBloc, CourseState>(
          builder: (context, state) {
            if (state is CourseLoaded) {
              return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: state.data.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CourseModulesPage(
                                        data: state.data[index],
                                        title: state.data[index]['name'],
                                      )),
                            );
                          },
                          child: Column(
                            children: [
                              Stack(children: [
                                CourseCard(data: state.data[index]),
                                Positioned(
                                    child: InkWell(
                                  onTap: () {
                                    BlocProvider.of<CourseBloc>(context)
                                      ..add(CourseDelete(
                                          id: state.data[index]['id']));
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    size: 30,
                                    color: Colors.red,
                                  ),
                                )),
                                Positioned(
                                    right: 2,
                                    child: GestureDetector(
                                      onTap: () {
                                        BlocProvider.of<CreateBloc>(context)
                                          ..add(CreateLoad(
                                              id: state.data[index]['id']));
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CreateCourseScreen(
                                                    title: 'Курсты өзгерту',
                                                  )),
                                        );
                                      },
                                      child: Icon(
                                        Icons.edit_note,
                                        size: 33,
                                        color: Colors.black,
                                      ),
                                    )),
                              ]),
                            ],
                          )),
                    );
                  });
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
