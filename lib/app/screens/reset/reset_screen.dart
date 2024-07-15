import 'package:big_qazaq_app/app/data/const/app_colors.dart';
import 'package:big_qazaq_app/app/screens/login/components/verify_screen.dart';
import 'package:big_qazaq_app/app/screens/reset/bloc/reset_bloc.dart';
import 'package:big_qazaq_app/app/screens/reset/components/reset_pin_verify_page.dart';
import 'package:big_qazaq_app/app/widgets/buttons/custom_button.dart';
import 'package:big_qazaq_app/app/widgets/textfields/custom_phone_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetScreen extends StatelessWidget {
  const ResetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController phone = TextEditingController();
    return Scaffold(
      backgroundColor: AppColors.kPrimaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.kSecondartBackgroundColor,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            ),
            Center(
              child: Text(
                'Парольді қалпына келтіру',
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(
              width: 50,
            ),
          ],
        ),
      ),
      body: BlocListener<ResetBloc, ResetState>(
        listener: (context, state) {
          if (state is ResetSendedOTP) {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => ResetVerifyCodePage(
                        phone: state.userPhone,
                        userId: state.userId,
                        pin: state.pin,
                      )),
            );
          }
          if (state is ResetError) {
            var snackBar = SnackBar(
              content: Text(state.message),
            );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                Text(
                  'Номер телефоныңызды жазыңыз',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 25,
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
                    SizedBox(width: 15),
                    Flexible(
                      child: TextFieldInput(
                        hintText: 'Телефон номеріңіз',
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
                CustomButton(
                  text: 'Код жіберу',
                  function: () {
                    BlocProvider.of<ResetBloc>(context)
                      ..add(ResetSendOTP(phone: phone.text));
                  },
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
