import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:task_offline/services/firebase_auth_services.dart';
import 'package:task_offline/services/locator.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationInitial());
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
   if (event is AuthenticationStarted) {
      yield* _mapAuthenticationStartedToState();
    } else if (event is AuthenticationLoggedOut) {
      yield* _mapAuthenticationLoggedOutToState();
    }
  }

    Stream<AuthenticationState> _mapAuthenticationStartedToState() async* {
    if (_firebaseAuthService.isSignIn()) {
      final user = _firebaseAuthService.getUser();
      yield AuthenticationSuccess('Logged in Successfully',
          displayName: user.uid,phoneNumber: user.phoneNumber);
    }   else {
      yield AuthenticationFailure('Signed out successfully');
    }
  }
    Stream<AuthenticationState> _mapAuthenticationLoggedOutToState() async* {
    // await _userBloc.logOut();
    await _firebaseAuthService.signOut();
    yield AuthenticationFailure('Signed out successfully');
  }
}
