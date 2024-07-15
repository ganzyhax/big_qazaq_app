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

class ProfileEditModal extends StatefulWidget {
  final String name;
  ProfileEditModal({required this.name});
  @override
  _ProfileEditModalState createState() => _ProfileEditModalState();
}

class _ProfileEditModalState extends State<ProfileEditModal> {
  TextEditingController name = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name.text = widget.name;
  }

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
                    CustomTextField(hintText: '', controller: name),
                    SizedBox(
                      height: 15,
                    ),
                    CustomButton(
                      text: 'Өзгерту',
                      function: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await ApiClient().updateFieldById(
                            'users',
                            await prefs.getString('userId') ?? '',
                            'name',
                            name.text);
                        BlocProvider.of<UsersBloc>(context)..add(UsersLoad());
                        BlocProvider.of<HomeBloc>(context)..add(HomeLoad());
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
