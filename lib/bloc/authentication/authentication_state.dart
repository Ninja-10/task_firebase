part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationSuccess extends AuthenticationState {
  final String successMessage;
  final String displayName;
  final String phoneNumber;

  AuthenticationSuccess(this.successMessage, {this.displayName,this.phoneNumber});

  @override
  String toString() => 'AuthenticationSuccess { displayName: $displayName }';
}

class AuthenticationFailure extends AuthenticationState {
  final String errorMessage;

  AuthenticationFailure(this.errorMessage);
}