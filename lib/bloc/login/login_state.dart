part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}


class LoginValidation extends LoginState {
  final String phoneNumberError;

  LoginValidation(
      {this.phoneNumberError});
}

class LoginSubmitting extends LoginState {}

class LoadingState extends LoginState {}


class LoginSuccessFul extends LoginState {
  final User user;

  LoginSuccessFul({this.user});
}

class LoginFailed extends LoginState {
  final String message;

  LoginFailed({this.message});
}

class UserAlreadyExists extends LoginState {}

class OtpSent extends LoginState {}

class OtpAutoRetrievalTimeOut extends LoginState {}

class UserIsNotExists extends LoginState {}

