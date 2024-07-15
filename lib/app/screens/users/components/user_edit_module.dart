import 'dart:developer';

import 'package:big_qazaq_app/api/api.dart';
import 'package:big_qazaq_app/app/screens/users/bloc/users_bloc.dart';
import 'package:big_qazaq_app/app/widgets/buttons/custom_button.dart';
import 'package:big_qazaq_app/app/widgets/textfields/custom_phone_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

class UserEditModal extends StatefulWidget {
  int courseLength;
  final data;
  UserEditModal({required this.courseLength, required this.data});
  @override
  _UserEditModalState createState() => _UserEditModalState();
}

class _UserEditModalState extends State<UserEditModal> {
  TextEditingController phone = TextEditingController();

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
                    SizedBox(
                      height: 15,
                    ),
                    CustomButton(
                      text: 'Қабылдау',
                      function: () async {
                        var courses = [];
                        for (var s = 0; s < checkBoxValues.length; s++) {
                          if (checkBoxValues[s] == true) {
                            courses.add(state.courses[s]['id']);
                          }
                        }
                        await ApiClient().updateFieldById(
                            'users', widget.data['id'], "courses", courses);
                        BlocProvider.of<UsersBloc>(context)..add(UsersLoad());
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Жаңарды!')),
                        );

                        Navigator.pop(context);
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
