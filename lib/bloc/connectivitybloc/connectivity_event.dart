part of 'connectivity_bloc.dart';

@immutable
abstract class ConnectivityEvent {}

class ConnectivityLoad extends ConnectivityEvent {}

class ConnectivityWrapper extends ConnectivityEvent {
  final ConnectivityState state;

  ConnectivityWrapper(this.state);
}
