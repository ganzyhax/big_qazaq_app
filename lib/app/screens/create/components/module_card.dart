import 'dart:developer';

import 'package:big_qazaq_app/app/screens/course/bloc/course_bloc.dart';
import 'package:big_qazaq_app/app/screens/create/components/create_pdf_files_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:big_qazaq_app/app/screens/create/bloc/create_bloc.dart';
import 'package:big_qazaq_app/app/widgets/buttons/custom_button.dart';
import 'package:big_qazaq_app/app/widgets/textfields/custom_textfiled.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ExpandableLesson extends StatefulWidget {
  final String title;
  final List<dynamic> lessons;
  final int index;

  ExpandableLesson({
    required this.title,
    required this.lessons,
    required this.index,
  });

  @override
  State<ExpandableLesson> createState() => _ExpandableLessonState();
}

class _ExpandableLessonState extends State<ExpandableLesson> {
  TextEditingController lessonNameController = TextEditingController();
  TextEditingController _tokenTextController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  bool isShowPdf = false;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateBloc, CreateState>(
      builder: (context, state) {
        if (state is CreateLoaded) {
          return Row(
            children: [
              Expanded(
                child: Card(
                    child: ExpansionTile(
                        onExpansionChanged: (b) {
                          isShowPdf = b;
                          setState(() {});
                        },
                        title: Text(
                          widget.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        children: widget.lessons.map<Widget>((lesson) {
                          String lessonName = lesson['lessonName'];
                          int lIndex = widget.lessons.indexOf(lesson);
                          return ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {},
                                      child: CircleAvatar(
                                        radius: 17,
                                        backgroundColor:
                                            Colors.deepPurpleAccent,
                                        child: Icon(
                                          Icons.play_arrow,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.05,
                                        child: Text(lessonName)),
                                  ],
                                ),
                                state.isDownloadDone[widget.index][lIndex]
                                    ? Row(
                                        children: [
                                          Icon(Icons.download_done),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              BlocProvider.of<CreateBloc>(
                                                  context)
                                                ..add(CreateRemoveLesson(
                                                    lessonName: lessonName,
                                                    moduleName: widget.title));
                                            },
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          )
                                        ],
                                      )
                                    : state.isDownloadStarted[widget.index]
                                            [lIndex]
                                        ? SizedBox(
                                            width: 40,
                                            child: CircularPercentIndicator(
                                              radius: 15.0,
                                              lineWidth: 5.0,
                                              percent:
                                                  state.progresses[widget.index]
                                                      [lIndex],
                                              header: new Text(
                                                (state.progresses[widget.index]
                                                                [lIndex] *
                                                            100)
                                                        .toInt()
                                                        .toString() +
                                                    '%',
                                                style: TextStyle(fontSize: 12),
                                              ),
                                              backgroundColor: Colors.grey,
                                              progressColor: Colors.black,
                                            ),
                                          )
                                        : Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  BlocProvider.of<CreateBloc>(
                                                      context)
                                                    ..add(CreateVideoUpload(
                                                      moduleName: widget.title,
                                                      lessonName: lessonName,
                                                    ));
                                                },
                                                child: Icon(Icons.upload_file),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  BlocProvider.of<CreateBloc>(
                                                      context)
                                                    ..add(CreateRemoveLesson(
                                                        lessonName: lessonName,
                                                        moduleName:
                                                            widget.title));
                                                },
                                                child: GestureDetector(
                                                  onTap: () {
                                                    BlocProvider.of<CreateBloc>(
                                                        context)
                                                      ..add(CreateRemoveLesson(
                                                          lessonName:
                                                              lessonName,
                                                          moduleName:
                                                              widget.title));
                                                  },
                                                  child: Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                              ],
                            ),
                          );
                        }).toList()
                          ..add(
                            ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: CustomTextField(
                                      hintText: 'Сабақтың аты',
                                      controller: lessonNameController,
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  CustomButton(
                                    text: 'Қосу',
                                    function: () {
                                      BlocProvider.of<CreateBloc>(context).add(
                                        CreateAddLesson(
                                          lessonName: lessonNameController.text,
                                          moduleName: widget.title,
                                        ),
                                      );
                                      lessonNameController.text = '';
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ))),
              ),
              (!isShowPdf)
                  ? GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CreatePdfFilesModal(
                                data: state.module[widget
                                    .index]); // Replace with your dialog widget
                          },
                        );
                      },
                      child: (state.isUploadingPdf[widget.index] == true)
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: Colors.black,
                              ),
                            )
                          : Icon(
                              Icons.picture_as_pdf,
                              color: Colors.red,
                            ),
                    )
                  : SizedBox()
            ],
          );
        }
        return Center(
          child: CircularPercentIndicator(
            radius: 25,
          ),
        );
      },
    );
  }
}
