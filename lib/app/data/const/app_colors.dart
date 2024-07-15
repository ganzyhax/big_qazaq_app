import 'package:flutter/material.dart';

class AppColors {
  final LinearGradient kPrimaryGradientGreenColor = const LinearGradient(
    colors: [Color.fromARGB(255, 0, 0, 0), Color.fromARGB(255, 0, 0, 0)],
    stops: [0.25, 0.75],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  final LinearGradient kPrimaryGradientGrey = const LinearGradient(
    colors: [Color(0xff9fadb9), Color(0xff9fadb9)],
    stops: [0.25, 0.75],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  final LinearGradient kPrimaryGradientWhite = const LinearGradient(
    colors: [Color(0xffffffff), Color(0xffffffff)],
    stops: [0.25, 0.75],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static final Color primary = Colors.black;
  static final Color secondart = Colors.blueGrey;
  static final Color kPrimaryBackgroundColor = Color(0xFFF6F7FA);
  static final Color kSecondartBackgroundColor = Colors.white;
}
