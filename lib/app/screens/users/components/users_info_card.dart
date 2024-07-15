import 'package:flutter/material.dart';

class UsersInfoCard extends StatelessWidget {
  final String title;
  final String subTitle;

  const UsersInfoCard({super.key, required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2.1,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          subTitle,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        )
      ]),
    );
  }
}
