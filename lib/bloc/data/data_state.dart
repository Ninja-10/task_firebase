part of 'data_bloc.dart';

@immutable
abstract class DataState {}

class DataInitial extends DataState {}

class DataLoading extends DataState{}

class DataSubmittedSuccessfully extends DataState{

  DataSubmittedSuccessfully();


}

class DataFailed extends DataState{
  final String message;
  DataFailed({this.message});
}

class DataFetched extends DataState{
  final List<FormData> data;

  DataFetched({this.data});


}
