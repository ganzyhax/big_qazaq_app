import 'package:big_qazaq_app/api/api.dart';
import 'package:big_qazaq_app/app/data/const/app_colors.dart';
import 'package:big_qazaq_app/app/screens/navigator/main_navigator.dart';
import 'package:big_qazaq_app/app/screens/reset/components/reset_pin_change_password_page.dart';
import 'package:big_qazaq_app/app/widgets/buttons/custom_button.dart';
import 'package:big_qazaq_app/app/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResetVerifyCodePage extends StatelessWidget {
  final String phone;
  final String userId;
  final String pin;

  const ResetVerifyCodePage(
      {super.key,
      required this.phone,
      required this.pin,
      required this.userId});

  @override
  Widget build(BuildContext context) {
    TextEditingController pinput = TextEditingController();
    return Scaffold(
      backgroundColor: AppColors.kPrimaryBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 16.0, bottom: 16.0),
                  height: MediaQuery.of(context).size.height / 3,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                        image: NetworkImage(
                            'https://play-lh.googleusercontent.com/MjrPI6DZ82LTP0Gt6MtJrAruaAUIa4mj029OJDOpwiyNC4HLcqljzDVohqjDWEhoNl0')),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.0),
                      topRight: Radius.circular(24.0),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 3.2),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 1.5,
                    decoration: BoxDecoration(
                      color: AppColors.kPrimaryBackgroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Тексеру',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          child: Text(
                            'Телефон нөміріңізге жіберген тексеру кодын енгізіңіз $phone',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 17),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Pinput(
                            onCompleted: (String? value) async {
                              if (value.toString() == pin) {
                                // SharedPreferences prefs =
                                //     await SharedPreferences.getInstance();
                                // await prefs.setString('userId', userId);
                                // await ApiClient().updateFieldById(
                                //     'users', userId, 'isVerified', true);
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => ChangePasswordPage(
                                            userId: userId,
                                          )),
                                  (Route<dynamic> route) => false,
                                );
                              } else {
                                CustomSnackBar.show(
                                    context, 'Incorrect pin code!', false);
                              }
                            },
                            autofocus: false,
                            length: 5,
                            androidSmsAutofillMethod:
                                AndroidSmsAutofillMethod.smsUserConsentApi,
                            controller: pinput,
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Код келмеді ме? ',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 15),
                            ),
                            Text(
                              'Жіберу',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.black),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),

            // Center(
            //   child: TextButton(
            //       onPressed: () {},
            //       child: Text(
            //         'Resend code',
            //         style: TextStyle(color: AppColors.kPrimaryGreen),
            //       )),
            // )
          ],
        ),
      ),
    );
  }
}
