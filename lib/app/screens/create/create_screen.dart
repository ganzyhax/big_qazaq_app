import 'package:big_qazaq_app/api/api.dart';
import 'package:big_qazaq_app/api/video_api.dart';
import 'package:big_qazaq_app/app/data/const/app_colors.dart';
import 'package:big_qazaq_app/app/screens/course/bloc/course_bloc.dart';
import 'package:big_qazaq_app/app/screens/create/bloc/create_bloc.dart';
import 'package:big_qazaq_app/app/screens/functions/global_functions.dart';
import 'package:big_qazaq_app/app/screens/home/bloc/home_bloc.dart';
import 'package:big_qazaq_app/app/screens/create/components/module_card.dart';
import 'package:big_qazaq_app/app/widgets/buttons/custom_button.dart';
import 'package:big_qazaq_app/app/widgets/textfields/custom_textfiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateCourseScreen extends StatefulWidget {
  final String title;
  const CreateCourseScreen({super.key, required this.title});

  @override
  State<CreateCourseScreen> createState() => _CreateCourseScreenState();
}

class _CreateCourseScreenState extends State<CreateCourseScreen> {
  TextEditingController courseName = TextEditingController();
  String courseImage =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQwv46YCfHPbpoKfMgs7WoldS_zQKBZgyUWhR26m7vAM83-iT4TAi7ZFiVVk4GlMjRRFjs&usqp=CAU';
  TextEditingController moduleName = TextEditingController();

  bool showAddModule = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateBloc, CreateState>(
      listener: (context, state) {
        if (state is CreateEditState) {
          courseImage = state.courseImage;
          courseName.text = state.courseName;
          setState(() {});
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.kSecondartBackgroundColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
              ),
              Center(
                child: Text(
                  widget.title,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ),
              SizedBox(
                width: 15,
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: BlocBuilder<CreateBloc, CreateState>(
            builder: (context, state) {
              if (state is CreateLoaded) {
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.kSecondartBackgroundColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                String imageUrl = await GlobalFunctions()
                                    .uploadImageToImgBB(context);
                                if (imageUrl != 'null') {
                                  courseImage = imageUrl;
                                  setState(() {});
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Қате!')),
                                  );
                                }
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width / 3,
                                height: 150,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(courseImage))),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomTextField(
                                      hintText: 'Курстың аты',
                                      controller: courseName),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        color: Color.fromRGBO(14, 67, 110, 1),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Batraliyev',
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(14, 67, 110, 1)),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white),
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Модульдер',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500),
                                ),
                                (showAddModule == false)
                                    ? GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            showAddModule = true;
                                          });
                                        },
                                        child: Icon(Icons.add))
                                    : SizedBox(),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            ListView.builder(
                              itemCount: state.module.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return ExpandableLesson(
                                  index: index,
                                  title: state.module[index]['moduleName'],
                                  lessons: state.module[index]['lessons'],
                                );
                              },
                            ),
                            (showAddModule)
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: CustomTextField(
                                            hintText: 'Модульдің аты',
                                            controller: moduleName),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      CustomButton(
                                        function: () {
                                          BlocProvider.of<CreateBloc>(context)
                                            ..add(CreateAddModule(
                                                moduleName: moduleName.text));
                                          showAddModule = false;
                                          moduleName.text = '';
                                          setState(() {});
                                        },
                                        text: 'Қосу',
                                      )
                                    ],
                                  )
                                : SizedBox(),
                            SizedBox(
                              height: 15,
                            ),
                            CustomButton(
                              text: (widget.title == 'Курсты өзгерту')
                                  ? 'Өзгерту'
                                  : 'Қосу',
                              function: () async {
                                BlocProvider.of<CreateBloc>(context)
                                  ..add(CreateCreateFinally(
                                      courseImage: courseImage,
                                      courseName: courseName.text));
                                courseImage =
                                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQwv46YCfHPbpoKfMgs7WoldS_zQKBZgyUWhR26m7vAM83-iT4TAi7ZFiVVk4GlMjRRFjs&usqp=CAU';
                                courseName.text = '';
                                moduleName.text = '';
                                BlocProvider.of<CourseBloc>(context)
                                  ..add(CourseLoad());
                                setState(() {});
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }
}
