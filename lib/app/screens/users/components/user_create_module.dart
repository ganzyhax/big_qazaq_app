import 'package:big_qazaq_app/api/api.dart';
import 'package:big_qazaq_app/app/screens/users/bloc/users_bloc.dart';
import 'package:big_qazaq_app/app/widgets/buttons/custom_button.dart';
import 'package:big_qazaq_app/app/widgets/textfields/custom_phone_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

class UserCreateModal extends StatefulWidget {
  int courseLength;
  UserCreateModal({required this.courseLength});
  @override
  _UserCreateModalState createState() => _UserCreateModalState();
}

class _UserCreateModalState extends State<UserCreateModal> {
  TextEditingController phone = TextEditingController();
  String password = '';
  String error = '';
  var checkBoxValues = [];
  @override
  void initState() {
    super.initState();
    checkBoxValues = List.generate(widget.courseLength, (index) => false);
  }

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
                          'Жаңа аккаунт ашу',
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
                            hintText: 'Телефон номері',
                            textInputType: TextInputType.phone,
                            textEditingController: phone,
                            isPhoneInput: true,
                            autoFocus: true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Курстар',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Column(
                      children: state.courses.map<Widget>((e) {
                        int index = state.courses.indexOf(e);
                        return Row(
                          children: [
                            Checkbox(
                              checkColor: Colors.white,
                              activeColor: Colors.black,
                              value: checkBoxValues[index],
                              onChanged: (newValue) {
                                setState(() {
                                  checkBoxValues[index] = newValue;
                                });
                              },
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(e['name'])
                          ],
                        );
                      }).toList(),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    (password != '')
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Логин: ' + phone.text),
                                  Row(
                                    children: [
                                      Text('Пароль: '),
                                      SizedBox(width: 5),
                                      Text(password)
                                    ],
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () async {
                                  String p = phone.text;
                                  await Clipboard.setData(
                                      ClipboardData(text: '''
Логин: $p\nПароль: xQjermu01

                              '''));
                                  // Optionally show a snackbar or toast message
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Көшірілді')),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: Icon(Icons.copy),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.grey[200]),
                                ),
                              )
                            ],
                          )
                        : SizedBox(),
                    (error != '')
                        ? Row(
                            children: [
                              Text(
                                error,
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          )
                        : SizedBox(),
                    SizedBox(
                      height: 15,
                    ),
                    (password != '')
                        ? SizedBox()
                        : CustomButton(
                            text: 'Ашу',
                            function: () async {
                              error = '';
                              setState(() {});
                              var courses = [];
                              for (var s = 0; s < checkBoxValues.length; s++) {
                                for (var i = 0; i < state.courses.length; i++) {
                                  if (checkBoxValues[s] == true) {
                                    courses.add(state.courses[i]['id']);
                                  }
                                }
                              }
                              bool isExist = await ApiClient().checkFieldExist(
                                  'users', 'phone', phone.text);
                              if (!isExist) {
                                var data = {
                                  'name': "Не указано",
                                  'courses': courses,
                                  'image':
                                      'https://upload.wikimedia.org/wikipedia/commons/e/e0/Userimage.png',
                                  'isAdmin': false,
                                  'isVerified': false,
                                  'password': 'xQjermu01',
                                  'phone': phone.text,
                                };
                                await ApiClient()
                                    .addDocument('users', data, true);

                                BlocProvider.of<UsersBloc>(context)
                                  ..add(UsersLoad());
                                password = 'xQjermu01';
                                setState(() {});
                              } else {
                                error = 'Бұндай номермен қолданушы бар!';
                                setState(() {});
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
