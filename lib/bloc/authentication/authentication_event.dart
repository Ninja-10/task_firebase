part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent {}

class AuthenticationStarted extends AuthenticationEvent {}


class AuthenticationLoggedOut extends AuthenticationEvent {}