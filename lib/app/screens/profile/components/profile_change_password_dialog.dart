import 'package:big_qazaq_app/api/api.dart';
import 'package:big_qazaq_app/app/screens/home/bloc/home_bloc.dart';
import 'package:big_qazaq_app/app/screens/users/bloc/users_bloc.dart';
import 'package:big_qazaq_app/app/widgets/buttons/custom_button.dart';
import 'package:big_qazaq_app/app/widgets/textfields/custom_phone_textfield.dart';
import 'package:big_qazaq_app/app/widgets/textfields/custom_textfiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileChangePasswordModal extends StatefulWidget {
  final String password;
  ProfileChangePasswordModal({required this.password});
  @override
  _ProfileChangePasswordModalState createState() =>
      _ProfileChangePasswordModalState();
}

class _ProfileChangePasswordModalState
    extends State<ProfileChangePasswordModal> {
  TextEditingController password = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController rnewPassword = TextEditingController();
  bool isShowPassword = true;
  bool isnShowPassword = true;
  bool isrnShowPassword = true;
  var checkBoxValues = [];
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white, // Background color of the modal
          ),
          child: BlocBuilder<UsersBloc, UsersState>(
            builder: (context, state) {
              if (state is UsersLoaded) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Өзгерту',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close))
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      child: CustomTextField(
                          onTapIcon: () {
                            setState(() {
                              if (isShowPassword) {
                                isShowPassword = false;
                              } else {
                                isShowPassword = true;
                              }
                            });
                          },
                          isPassword: true,
                          passwordShow: isShowPassword,
                          hintText: 'Қазіргі парольіңізді еңгізіңіз',
                          controller: password),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CustomTextField(
                        onTapIcon: () {
                          setState(() {
                            if (isnShowPassword) {
                              isnShowPassword = false;
                            } else {
                              isnShowPassword = true;
                            }
                          });
                        },
                        isPassword: true,
                        passwordShow: isnShowPassword,
                        hintText: 'Жаңа парольді жазыңыз',
                        controller: newPassword),
                    SizedBox(
                      height: 15,
                    ),
                    CustomTextField(
                        onTapIcon: () {
                          setState(() {
                            if (isrnShowPassword) {
                              isrnShowPassword = false;
                            } else {
                              isrnShowPassword = true;
                            }
                          });
                        },
                        isPassword: true,
                        passwordShow: isrnShowPassword,
                        hintText: 'Жаңа парольді қайталаңыз',
                        controller: rnewPassword),
                    SizedBox(
                      height: 15,
                    ),
                    CustomButton(
                      text: 'Өзгерту',
                      function: () async {
                        if (password.text == widget.password) {
                          if (newPassword.text == rnewPassword.text) {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await ApiClient().updateFieldById(
                                'users',
                                await prefs.getString('userId') ?? '',
                                'password',
                                rnewPassword.text);
                            BlocProvider.of<HomeBloc>(context)..add(HomeLoad());
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Пароль өзгерді')),
                            );
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Парольдар сәйкес келмейді!')),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Пароль қате!')),
                          );
                        }
                      },
                    )
                  ],
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ));
  }
}
