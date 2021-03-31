part of 'data_bloc.dart';

@immutable
abstract class DataEvent {}
class DataStarted extends DataEvent{}
class DataSubmit extends DataEvent{
  final String name;
  final String phoneNumber;
  final String imageUrl;
  final double lat;
  final double lng;
  final String uuid;

  DataSubmit({this.name,this.imageUrl,this.phoneNumber,this.lat,this.lng,this.uuid});

}

class DataFetch extends DataEvent{
  
}

class DataUpdate extends DataEvent{
  final String id;
  final String key;
  final String value;
  DataUpdate({this.id,this.key,this.value});
}