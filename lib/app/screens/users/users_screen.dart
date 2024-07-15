import 'dart:developer';

import 'package:big_qazaq_app/app/data/const/app_colors.dart';
import 'package:big_qazaq_app/app/screens/users/bloc/users_bloc.dart';
import 'package:big_qazaq_app/app/screens/users/components/user_card.dart';
import 'package:big_qazaq_app/app/screens/users/components/user_create_module.dart';
import 'package:big_qazaq_app/app/screens/users/components/users_info_card.dart';
import 'package:big_qazaq_app/app/widgets/textfields/custom_phone_textfield.dart';
import 'package:big_qazaq_app/app/widgets/textfields/custom_textfiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController phone = TextEditingController();
    return BlocBuilder<UsersBloc, UsersState>(builder: (context, state) {
      if (state is UsersLoaded) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Scaffold(
              appBar: AppBar(
                backgroundColor: AppColors.kSecondartBackgroundColor,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 50,
                    ),
                    Text(
                      'Қолданушылар',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return UserCreateModal(
                              courseLength: state.courses.length,
                            ); // Replace with your dialog widget
                          },
                        );
                      },
                      child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.black),
                          child: Icon(Icons.add)),
                    )
                  ],
                ),
              ),
              body: SingleChildScrollView(
                child: BlocBuilder<UsersBloc, UsersState>(
                  builder: (context, state) {
                    if (state is UsersLoaded) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                UsersInfoCard(
                                    title: 'Қолданушылар саны',
                                    subTitle: state.data.length.toString()),
                                UsersInfoCard(
                                    title: 'Шамамен пайда',
                                    subTitle: state.courses.length.toString()),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextFieldInput(
                              onChanged: (text) {
                                BlocProvider.of<UsersBloc>(context)
                                  ..add(UsersSearch(searchText: text));
                              },
                              hintText: 'Номер телефон арқылы іздеу',
                              textInputType: TextInputType.number,
                              textEditingController: phone,
                              isPhoneInput: true,
                              autoFocus: false,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: state.data.length,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: ((context, index) {
                                  // log(state.data[index]['coursesData'].length
                                  //     .toString());
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Stack(
                                      children: [
                                        UserCard(
                                            data: state.data[index],
                                            courseLength: state.courses.length),
                                        Positioned(
                                            left: 0,
                                            child: GestureDetector(
                                              onDoubleTap: () {
                                                BlocProvider.of<UsersBloc>(
                                                    context)
                                                  ..add(UsersDelete(
                                                      userId: state.data[index]
                                                          ['id']));
                                              },
                                              child: Icon(
                                                Icons.delete,
                                                size: 25,
                                                color: Colors.red,
                                              ),
                                            )),
                                      ],
                                    ),
                                  );
                                })),
                          ],
                        ),
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    );
                  },
                ),
              )),
        );
      }
      return Center(
        child: CircularProgressIndicator(),
      );
    });
  }
}
