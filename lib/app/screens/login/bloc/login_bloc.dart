import 'dart:developer';

import 'package:big_qazaq_app/api/api.dart';
import 'package:big_qazaq_app/app/screens/login/components/function.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginEvent>((event, emit) async {
      if (event is LoginLoad) {
        emit(LoginLoaded());
      }
      if (event is LoginLog) {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        var user = await ApiClient().login(event.phone, event.pass);

        if (user != null) {
          if (user['isAdmin'] ?? false == true) {
            await prefs.setBool('isAdmin', true);
          }
          if (user['isVerified'] == true) {
            await prefs.setString('userId', user['userId']);
            emit(LoginSuccess());
          } else {
            String pin = SignFunctions().generateRandomPin().toString();
            bool isSuccess = await SignFunctions().sendVerificationCode(
                phoneNumber: '7' + event.phone, generatedCode: pin);
            if (isSuccess) {
              emit(LoginVerify(
                  pin: pin, userId: user['userId'], userPhone: event.phone));
            } else {
              emit(LoginError());
            }
          }
          emit(LoginLoaded());
        } else {
          emit(LoginError());
          emit(LoginLoaded());
        }
      }
    });
  }
}
