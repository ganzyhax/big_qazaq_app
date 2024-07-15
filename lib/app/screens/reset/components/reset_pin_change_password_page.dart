import 'package:big_qazaq_app/api/api.dart';
import 'package:big_qazaq_app/app/data/const/app_colors.dart';
import 'package:big_qazaq_app/app/screens/login/login_screen.dart';
import 'package:big_qazaq_app/app/widgets/buttons/custom_button.dart';
import 'package:big_qazaq_app/app/widgets/textfields/custom_textfiled.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  final String userId;

  const ChangePasswordPage({super.key, required this.userId});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  TextEditingController password = TextEditingController();
  TextEditingController rPassword = TextEditingController();
  bool passwordShow = true;
  bool rpasswordShow = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kSecondartBackgroundColor,
        title: Row(
          children: [
            Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            ),
            Text(
              'Жаңа пароль еңгізу',
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(
              width: 50,
            )
          ],
        ),
      ),
      backgroundColor: AppColors.kPrimaryBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 5.5,
              ),
              Center(
                child: Text(
                  'Парольді ауыстыру',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 19,
                      fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              CustomTextField(
                controller: password,
                hintText: '********',
                isPassword: true,
                passwordShow: passwordShow,
                onTapIcon: () {
                  if (passwordShow) {
                    setState(() {
                      passwordShow = false;
                    });
                  } else {
                    setState(() {
                      passwordShow = true;
                    });
                  }
                },
              ),
              SizedBox(
                height: 15,
              ),
              CustomTextField(
                controller: rPassword,
                hintText: '********',
                isPassword: true,
                passwordShow: rpasswordShow,
                onTapIcon: () {
                  if (rpasswordShow) {
                    setState(() {
                      rpasswordShow = false;
                    });
                  } else {
                    setState(() {
                      rpasswordShow = true;
                    });
                  }
                },
              ),
              SizedBox(
                height: 15,
              ),
              CustomButton(
                text: 'Ауыстыру',
                function: () async {
                  if (rPassword.text == password.text) {
                    await ApiClient().updateFieldById(
                        'users', widget.userId, 'password', rPassword.text);
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        (Route<dynamic> route) => false);
                  } else {
                    var snackBar = SnackBar(
                      content: Text('Парольдар сәйкес келмейді!'),
                    );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
