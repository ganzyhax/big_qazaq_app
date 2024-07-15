import 'dart:developer';

import 'package:big_qazaq_app/app/data/const/app_colors.dart';
import 'package:big_qazaq_app/app/widgets/custom_pdf_reader.dart';
import 'package:big_qazaq_app/app/widgets/custom_video_player.dart';

import 'package:flutter/material.dart';

class CourseModulePage extends StatefulWidget {
  final String title;
  final String urlVideo;
  final data;
  final pdf;
  const CourseModulePage(
      {super.key,
      required this.title,
      required this.urlVideo,
      required this.pdf,
      required this.data});

  @override
  State<CourseModulePage> createState() => _CourseModulePageState();
}

class _CourseModulePageState extends State<CourseModulePage> {
  bool _isFullScreen = false;
  List<bool> video_visible_list = [true, true];
  void _onFullScreenChange(bool isFullScreen) {
    setState(() {
      _isFullScreen = isFullScreen;
      selectedTab = 1;
    });
  }

  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimaryBackgroundColor,
      appBar: _isFullScreen
          ? null
          : AppBar(
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
                widget.title,
                style: TextStyle(color: Colors.black),
              ),
            ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          children: [
            VideoPlayerWidget(
                onFullScreenChange: _onFullScreenChange, url: widget.urlVideo),
            (_isFullScreen)
                ? SizedBox()
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20, top: 20, bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedTab = 0;
                                });
                              },
                              child: Column(
                                children: [
                                  Text(
                                    'Видеолар',
                                    style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Container(
                                    height: (selectedTab == 0) ? 3 : 1,
                                    width: 100,
                                    color: Colors.black,
                                  )
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedTab = 1;
                                });
                              },
                              child: Column(
                                children: [
                                  Text(
                                    'Файлдар',
                                    style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Container(
                                    height: (selectedTab == 1) ? 3 : 1,
                                    width: 100,
                                    color: Colors.black,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      (selectedTab == 0)
                          ? Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: widget.data.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CourseModulePage(
                                                    data: widget.data,
                                                    pdf: widget.pdf,
                                                    urlVideo: widget.data[index]
                                                        ['lessonVideoUrl'],
                                                    title: widget.data[index]
                                                        ['lessonName'],
                                                  )),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: (widget.data[index]
                                                        ['lessonName'] ==
                                                    widget.title)
                                                ? Colors.grey[200]
                                                : null),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 150,
                                        padding: EdgeInsets.all(15),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(widget
                                                              .data[index][
                                                          'lessonVideoImage']))),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.2,
                                              height: 150,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 12.0),
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2.45,
                                                child: Text(
                                                  widget.data[index]
                                                      ['lessonName'],
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: ListView.builder(
                                itemCount: widget.pdf.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Container(
                                    color: Colors.white,
                                    child: ListTile(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => PDFScreen(
                                                pdfUrl: widget.pdf[index]
                                                    ['fileUrl'],
                                                title: widget.pdf[index]
                                                    ['fileName'],
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
                                            Text(widget.pdf[index]['fileName']),
                                          ],
                                        )),
                                  );

                                  // Convert Iterable<Widget> to List<Widget>
                                },
                              ),
                            ),
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
