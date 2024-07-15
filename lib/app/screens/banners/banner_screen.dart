import 'dart:developer';

import 'package:big_qazaq_app/api/api.dart';
import 'package:big_qazaq_app/app/app.dart';
import 'package:big_qazaq_app/app/data/const/app_colors.dart';
import 'package:big_qazaq_app/app/screens/banners/bloc/banner_bloc.dart';
import 'package:big_qazaq_app/app/screens/functions/global_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BannerScreen extends StatelessWidget {
  const BannerScreen({super.key});

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
            Center(
              child: Text(
                'Баннерлар',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
            ),
            GestureDetector(
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.clear();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => BigQazaqApp()),
                      (Route<dynamic> route) => false);
                },
                child: Icon(
                  Icons.logout,
                  color: Colors.black,
                ))
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<BannerBloc, BannerState>(builder: (context, state) {
          if (state is BannerLoaded) {
            log('sdsd');
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ListView.builder(
                      padding: EdgeInsets.all(0),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: state.banners.length,
                      itemBuilder: ((context, index) {
                        return Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Баннер ' + (index + 1).toString(),
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    BlocProvider.of<BannerBloc>(context)
                                      ..add(BannerDelete(
                                          id: state.banners[index]['id']));
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    size: 30,
                                    color: Colors.red,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width - 50,
                              height: 200,
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          state.banners[index]['image']))),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        );
                      })),
                  GestureDetector(
                    onTap: () async {
                      String imageUrl =
                          await GlobalFunctions().uploadImageToImgBB(context);
                      if (imageUrl != 'null') {
                        BlocProvider.of<BannerBloc>(context)
                          ..add(BannerAdd(imageUrl: imageUrl));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Қате!')),
                        );
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width - 50,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.add_a_photo,
                          size: 40,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          );
        }),
      ),
    );
  }
}
