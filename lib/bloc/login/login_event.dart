part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LoginStarted extends LoginEvent{

}

class SendOtpEvent extends LoginEvent{
  final String phoneNumber;


  SendOtpEvent({this.phoneNumber});
}

class VerifyOtpEvent extends LoginEvent{
  final String _otp;

  VerifyOtpEvent(this._otp);


}
class Wrapper extends LoginEvent {
  final LoginState state;

  Wrapper({this.state});
}

class SubmitOtpEvent extends LoginEvent {
  final String otp;

  SubmitOtpEvent(this.otp);
}

class LoginPhoneNumberChanged extends LoginEvent{
  final String phoneNumber;

  LoginPhoneNumberChanged(this.phoneNumber);
}

