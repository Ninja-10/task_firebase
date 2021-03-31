import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:task_offline/models/form_data.dart';
import 'package:task_offline/repositories/form_repository.dart';
import 'package:task_offline/services/locator.dart';

part 'data_event.dart';
part 'data_state.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  DataBloc() : super(DataInitial());

  FirebaseFormDataRepository _dataRepository = locator<FirebaseFormDataRepository>();

  @override
  Stream<DataState> mapEventToState(
    DataEvent event,
  ) async* {
      if(event is DataSubmit){
        try{
          FormData data = FormData(phoneNumber: event.phoneNumber,name: event.name,lat: event.lat,lng: event.lng,imageUrl: event.imageUrl, uuid:event.uuid);
          _dataRepository.addData(data);
          yield DataSubmittedSuccessfully();
        }catch(e){
          print(e);
          yield DataFailed(message:"Failed");
        }
      }else if(event is DataFetch){
        try{
            List<FormData> data = await  _dataRepository.getData();
            yield DataFetched(data: data);
        }catch(e){
           yield DataFailed(message:"Failed");
        }
        
      }else if(event is DataUpdate){
        try{
          _dataRepository.updateData(event.id, event.key, event.value);
        }catch(e){
           yield DataFailed(message:"Failed");
        }
      }
  }
}
