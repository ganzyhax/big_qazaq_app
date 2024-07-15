import 'dart:developer';

import 'package:big_qazaq_app/app/screens/course/bloc/course_bloc.dart';
import 'package:big_qazaq_app/app/screens/home/components/pages/watch/course_watch_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:big_qazaq_app/app/screens/create/bloc/create_bloc.dart';
import 'package:big_qazaq_app/app/widgets/buttons/custom_button.dart';
import 'package:big_qazaq_app/app/widgets/textfields/custom_textfiled.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ExpandableLessonShowCard extends StatelessWidget {
  final String title;
  final List<dynamic> lessons;
  final List<dynamic> pdf;

  final int index;

  ExpandableLessonShowCard({
    required this.title,
    required this.lessons,
    required this.index,
    required this.pdf,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ExpansionTile(
            title: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            children: lessons.map<Widget>((lesson) {
              String lessonName = lesson['lessonName'];
              int lIndex = lessons.indexOf(lesson);
              log(lIndex.toString());
              return ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (lesson['lessonVideoUrl'] != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CourseModulePage(
                                          data: lessons,
                                          pdf: pdf,
                                          urlVideo: lesson['lessonVideoUrl'],
                                          title: lessonName,
                                        )),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Қате, админге жазыңыз!')),
                              );
                            }
                          },
                          child: CircleAvatar(
                            radius: 17,
                            backgroundColor: Colors.deepPurpleAccent,
                            child: Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                            width: MediaQuery.of(context).size.width / 1.5,
                            child: Text(lessonName)),
                      ],
                    ),
                  ],
                ),
              );
            }).toList()));
  }
}
