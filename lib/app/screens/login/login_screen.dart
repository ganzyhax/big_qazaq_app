import 'dart:developer';

import 'package:big_qazaq_app/app/data/const/app_colors.dart';
import 'package:big_qazaq_app/app/screens/login/bloc/login_bloc.dart';
import 'package:big_qazaq_app/app/screens/login/components/function.dart';
import 'package:big_qazaq_app/app/screens/login/components/verify_screen.dart';
import 'package:big_qazaq_app/app/screens/navigator/main_navigator.dart';
import 'package:big_qazaq_app/app/screens/reset/reset_screen.dart';
import 'package:big_qazaq_app/app/widgets/custom_snackbar.dart';
import 'package:big_qazaq_app/app/widgets/textfields/custom_phone_textfield.dart';
import 'package:big_qazaq_app/app/widgets/textfields/custom_textfiled.dart';
import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/buttons/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController login = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController fa = TextEditingController();

  bool passwordShow = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimaryBackgroundColor,
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => CustomNavigationBar()),
                (Route<dynamic> route) => false);
          }
          if (state is LoginError) {
            CustomSnackBar.show(context, 'Логин немесе пароль қате!', false);
          }

          if (state is LoginVerify) {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => VerifyCodePage(
                        phone: state.userPhone,
                        userId: state.userId,
                        pin: state.pin,
                      )),
            );
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                if (state is LoginLoaded) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 4.5,
                      ),
                      Center(
                        child: Text(
                          'Кіру',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 50,
                            width: 65,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.07),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset(
                                  'assets/icons/kz-flag.png',
                                  width: 24,
                                ),
                                Text(
                                  '+7',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 3),
                          Flexible(
                            child: TextFieldInput(
                              hintText: 'Телефон номеріңіз',
                              textInputType: TextInputType.phone,
                              textEditingController: login,
                              isPhoneInput: true,
                              autoFocus: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('Құпия сөз'),
                      const SizedBox(
                        height: 10,
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
                      const SizedBox(
                        height: 40,
                      ),
                      CustomButton(
                        height: 40,
                        function: () {
                          BlocProvider.of<LoginBloc>(context)
                            ..add(LoginLog(
                                pass: password.text, phone: login.text));
                        },
                        text: 'Кіру',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.2,
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Жалғастыру арқылы сіз келісесіз ',
                                style: TextStyle(color: Colors.black),
                              ),
                              TextSpan(
                                style: TextStyle(color: Colors.blue),
                                text: 'ережелер мен шарттар ',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    const privacyUrl =
                                        'https://www.freeprivacypolicy.com/live/9ef13e42-ce91-4573-8c1e-6def6723dd55';
                                    if (await canLaunch(privacyUrl)) {
                                      await launch(privacyUrl);
                                    } else {
                                      log('sasd');
                                    }
                                  },
                              ),
                              TextSpan(
                                text: ' және ',
                                style: TextStyle(
                                    color: (Theme.of(context)
                                                .colorScheme
                                                .brightness ==
                                            Brightness.dark)
                                        ? Colors.white
                                        : Colors.black),
                              ),
                              TextSpan(
                                text: 'құпиялылық саясатпен',
                                style: TextStyle(color: Colors.blue),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    const privacyUrl =
                                        'https://www.freeprivacypolicy.com/live/7db8a8a5-5b51-4e0c-bb7e-c92e0b47d928';
                                    if (await canLaunch(privacyUrl)) {
                                      await launch(privacyUrl);
                                    } else {}
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Парольді ұмыттыңыз ба?' + ' '),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ResetScreen()),
                              );
                            },
                            child: Text(
                              'Қайтару',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          )
                        ],
                      )
                    ],
                  );
                }
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }
}
