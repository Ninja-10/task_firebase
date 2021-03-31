part of 'connectivity_bloc.dart';

@immutable
class ConnectivityState {
  final bool connected;
  final String message;

  ConnectivityState({this.connected, this.message});
}
