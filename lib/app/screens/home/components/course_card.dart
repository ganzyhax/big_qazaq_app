import 'package:big_qazaq_app/app/data/const/app_colors.dart';
import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final data;
  const CourseCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppColors.kSecondartBackgroundColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 3,
            height: 150,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(data['image'] ??
                        'https://t4.ftcdn.net/jpg/00/89/55/15/240_F_89551596_LdHAZRwz3i4EM4J0NHNHy2hEUYDfXc0j.jpg'))),
          ),
          SizedBox(
            width: 15,
          ),
          Container(
            width: MediaQuery.of(context).size.width / 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data['name'] ?? 'Жазылмаған',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        Text('5.0'),
                      ],
                    )
                  ],
                ),
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
                      style: TextStyle(color: Color.fromRGBO(14, 67, 110, 1)),
                    )
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Text(data['modules'].length.toString() + ' Модуль')
              ],
            ),
          )
        ],
      ),
    );
  }
}
