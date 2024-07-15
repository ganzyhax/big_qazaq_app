import 'dart:developer';

import 'package:big_qazaq_app/app/data/const/app_colors.dart';
import 'package:big_qazaq_app/app/screens/create/components/module_card.dart';
import 'package:big_qazaq_app/app/screens/home/components/pages/watch/%D1%81omponents/module_show_card.dart';
import 'package:big_qazaq_app/app/screens/home/components/pages/watch/course_watch_page.dart';
import 'package:big_qazaq_app/app/widgets/custom_pdf_reader.dart';
import 'package:big_qazaq_app/app/widgets/custom_video_player.dart';
import 'package:flutter/material.dart';

class CourseModulesPage extends StatelessWidget {
  final String title;
  final data;
  const CourseModulesPage({super.key, required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.kSecondartBackgroundColor,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 300,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover, image: NetworkImage(data['image']))),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    title,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: Colors.deepPurpleAccent,
                            size: 20,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'batralyev',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.deepPurpleAccent,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          Text('4.5'),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    color: Colors.black54,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Курс бағдарламасы',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                  ListView.builder(
                    padding: EdgeInsets.all(0),
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: data['modules'].length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ExpandableLessonShowCard(
                        pdf: data['modules'][index]['pdfFiles'] ?? [],
                        index: index,
                        title: data['modules'][index]['moduleName'],
                        lessons: data['modules'][index]['lessons'],
                      );
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Divider(),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Курс файлдары',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: data['modules'].length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return (data['modules'][index]['pdfFiles'] != null &&
                              data['modules'][index]['pdfFiles'].length != 0)
                          ? Card(
                              child: ExpansionTile(
                                  title: Text(
                                    data['modules'][index]['moduleName'],
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  children: data['modules'][index]['pdfFiles']
                                      .map<Widget>((e) {
                                    return ListTile(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => PDFScreen(
                                                pdfUrl: e['fileUrl'],
                                                title: e['fileName'],
                                              ),
                                            ),
                                          );
                                        },
                                        title: Row(
                                          children: [
                                            Icon(
                                              Icons.picture_as_pdf,
                                              color: Colors.red,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(e['fileName']),
                                          ],
                                        ));
                                  }).toList()),
                            )
                          : SizedBox();
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
