import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:meta/meta.dart';
import 'package:task_offline/services/connectivity_services.dart';
import 'package:task_offline/services/locator.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  ConnectivityBloc() : super(ConnectivityState(connected: true, message: null));
  ConnectivityService _connectivity = locator<ConnectivityService>();
  ConnectivityResult previousResult;

  @override
  Stream<ConnectivityState> mapEventToState(
    ConnectivityEvent event,
  ) async* {
    if (event is ConnectivityLoad) {
      yield* _mapConnectivityLoadToState();
    } else if (event is ConnectivityWrapper) {
      yield event.state;
    }
  }

  Stream<ConnectivityState> _mapConnectivityLoadToState() async* {
    _connectivity.onConnectivityChanged.listen((result) {
      if ((result == ConnectivityResult.wifi ||
              result == ConnectivityResult.mobile) &&
          (previousResult == ConnectivityResult.none ||
              previousResult == null)) {
        add(ConnectivityWrapper(
            ConnectivityState(connected: true, message: null)));
      } else if (result == ConnectivityResult.none &&
          (previousResult != ConnectivityResult.none ||
              previousResult == null)) {
        add(ConnectivityWrapper(ConnectivityState(
            connected: false, message: 'Connection offline')));
      }
      previousResult = result;
    });
  }
}
