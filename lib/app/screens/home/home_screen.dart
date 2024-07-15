import 'dart:developer';

import 'package:big_qazaq_app/app/data/const/app_colors.dart';
import 'package:big_qazaq_app/app/screens/home/bloc/home_bloc.dart';
import 'package:big_qazaq_app/app/screens/home/components/course_card.dart';
import 'package:big_qazaq_app/app/screens/home/components/pages/detail/course_detail_page.dart';
import 'package:big_qazaq_app/app/widgets/image_slideshow.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimaryBackgroundColor,
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoaded) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  NetworkImage(state.userData['image']),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Қош келдіңіз,',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                                Text(
                                  state.userData['name'],
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            )
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[200]),
                          child: Icon(
                            Icons.notifications,
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ImageSlideshow(
                        indicatorBackgroundColor: Colors.grey[200],
                        indicatorColor: Colors.black,
                        children: state.banners.map<Widget>((e) {
                          return Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    e['image'],
                                  ),
                                )),
                          );
                        }).toList()),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      'Менің курстарым',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    (state.userCourses.length > 0)
                        ? ListView.builder(
                            padding: EdgeInsets.all(0),
                            shrinkWrap: true,
                            itemCount: state.userCourses.length,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 15),
                                child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CourseModulesPage(
                                                  data:
                                                      state.userCourses[index],
                                                  title:
                                                      state.userCourses[index]
                                                          ['name'],
                                                )),
                                      );
                                    },
                                    child: CourseCard(
                                      data: state.userCourses[index],
                                    )),
                              );
                            })
                        : Text(
                            'Сізде курс жоқ :(',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          )
                  ],
                ),
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
