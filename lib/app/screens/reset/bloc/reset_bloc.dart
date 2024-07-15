import 'package:big_qazaq_app/api/api.dart';
import 'package:big_qazaq_app/app/screens/login/components/function.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'reset_event.dart';
part 'reset_state.dart';

class ResetBloc extends Bloc<ResetEvent, ResetState> {
  ResetBloc() : super(ResetInitial()) {
    on<ResetEvent>((event, emit) async {
      if (event is ResetSendOTP) {
        bool isExist =
            await ApiClient().checkFieldExist('users', 'phone', event.phone);

        if (isExist) {
          String? userId =
              await ApiClient().getUniqueFieldId('users', 'phone', event.phone);
          if (userId != null) {
            String pin = SignFunctions().generateRandomPin().toString();
            bool isSuccess = await SignFunctions().sendVerificationCode(
                phoneNumber: '7' + event.phone, generatedCode: pin);

            emit(ResetSendedOTP(
                userId: userId, pin: pin, userPhone: event.phone));
          }
        } else {
          emit(ResetError(
              message: 'Бұндай номер телефонмен қолданушы табылмады!'));
        }
      }
      if (event is ResetCheckOTP) {}
    });
  }
}
