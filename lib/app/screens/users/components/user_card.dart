import 'dart:developer';

import 'package:big_qazaq_app/app/screens/users/components/user_edit_module.dart';
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final data;
  final int courseLength;
  const UserCard({super.key, required this.data, required this.courseLength});

  @override
  Widget build(BuildContext context) {
    String courses = 'Курстары: ';
    // Using for loop to display course names
    for (var courseData in data['coursesData'])
      courses = courses + courseData['name'] + ',';
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment
            .spaceBetween, // Align children to the start and end of the row
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(data['image'].toString()),
            radius: 25,
            backgroundColor: Colors.white,
          ),
          SizedBox(
            width: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data['name'],
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 5),
              Text(
                data['phone'],
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 5),
              (data['coursesData'].length != 0)
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width / 1.9,
                      child: Text(courses))
                  : Text('Курстары жоқ')
            ],
          ),

          // Spacer to push the edit icon to the far right
          Spacer(),
          // Edit icon aligned on the right
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return UserEditModal(
                    courseLength: courseLength,
                    data: data,
                  ); // Replace with your dialog widget
                },
              );
            },
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.grey[200],
              ),
              child: Icon(Icons.edit),
            ),
          ),
        ],
      ),
    );
  }
}
