import 'dart:io';

import 'package:big_qazaq_app/api/api.dart';
import 'package:big_qazaq_app/app/screens/users/bloc/users_bloc.dart';
import 'package:big_qazaq_app/app/widgets/buttons/custom_button.dart';
import 'package:big_qazaq_app/app/widgets/textfields/custom_phone_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateModal extends StatefulWidget {
  @override
  _UpdateModalModalState createState() => _UpdateModalModalState();
}

class _UpdateModalModalState extends State<UpdateModal> {
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
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Жаңа жаңарту қолжетімді!',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    CustomButton(
                      text: 'Жаңарту',
                      function: () async {
                        if (Platform.isAndroid) {}
                        if (Platform.isIOS) {
                          final Uri url = Uri.parse(
                              'https://apps.apple.com/app/big-qazaq/id6529552599');
                          await launchUrl(url);
                        }
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
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
