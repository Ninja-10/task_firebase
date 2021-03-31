import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:task_offline/services/firebase_auth_services.dart';
import 'package:task_offline/services/locator.dart';
import 'package:task_offline/utils/appform_validation.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial());

  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  AppFormValidator _formValidator = locator<AppFormValidator>();

  String _verificationId;

  String _otp;

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is SendOtpEvent) {
      yield* _sendOtpEventToState(event.phoneNumber);
    } else if (event is SubmitOtpEvent) {
      yield* _submitOtpEventToState(event.otp);
    } else if (event is Wrapper) {
      yield* _wrapperEventToState(event.state);
    }
  }

  Stream<LoginState> _wrapperEventToState(LoginState state) async* {
    yield state;
  }

  Stream<LoginState> _sendOtpEventToState(String phone) async* {
    yield LoginSubmitting();
    String phoneNumber = phone;
    print('phoneNumber$phoneNumber');
    AppFormValidatorData validateData =
        _formValidator.validatePhoneNumber(phoneNumber);

    if (validateData.isValid) {
      bool isPhoneNumberExist =
          await _firebaseAuthService.isPhoneNumberExist(phoneNumber);
      print(isPhoneNumberExist);
      print("=========================================>");
      if (isPhoneNumberExist) {
        _inItPhoneVerification(phoneNumber);
      } else {
        yield UserIsNotExists();

        print('isUserExists: $isPhoneNumberExist');
      }
    } else {
      yield LoginFailed(message: "Not a valid number");
    }
  }

  _inItPhoneVerification(String phoneNumber) async {
    final phoneVerificationCompleted = (AuthCredential authCredential) {
      User user = _firebaseAuthService.getUser();
      add(Wrapper(state: LoginSuccessFul(user: user)));
    };

    final phoneVerificationFailed = (FirebaseAuthException authException) {
      print(authException.message);
      add(Wrapper(state: LoginFailed(message: authException.message)));
    };

    final phoneCodeSent = (String verificationId, int resendToken) {
      _verificationId = verificationId;
      print('codesent');
      add(Wrapper(state: OtpSent()));
    };

    final phoneCodeAutoRetrievalTimeOut = (String verificationId) {
      _verificationId = verificationId;
      add(Wrapper(state: OtpAutoRetrievalTimeOut()));
    };

    await _firebaseAuthService.sendOtp(
        phoneNumber: phoneNumber,
        timeOut: Duration(seconds: 30),
        phoneVerificationCompleted: phoneVerificationCompleted,
        phoneCodeSent: phoneCodeSent,
        phoneVerificationFailed: phoneVerificationFailed,
        autoRetrievalTimeout: phoneCodeAutoRetrievalTimeOut);
  }

  Stream<LoginState> _submitOtpEventToState(String otp) async* {
    yield LoginSubmitting();
    try {
      UserCredential userCredential =
          await _firebaseAuthService.verifyLogin(_verificationId, otp);

      if (userCredential.user != null) {
        yield LoginSuccessFul(user: userCredential.user);
        
      } else {
        yield LoginFailed(message: "Invalid otp!");
      }
    } catch (e) {
      yield LoginFailed(message: "Invalid otp!");
    }
  }
}
