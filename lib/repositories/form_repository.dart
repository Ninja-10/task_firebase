import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_offline/models/form_data.dart';

abstract class FormDataRepository{
  Future<void> addData(FormData data);
  Future<List<FormData>> getData();
  Future updateData(String id,String key,String value);
}

class FirebaseFormDataRepository extends FormDataRepository{
  final formDataCollection = FirebaseFirestore.instance.collection('form_data');

  @override
  Future<void> addData(FormData data) {
   return  formDataCollection.add(data.toJson());
  }

  @override
   Future<List<FormData>> getData() async{
    FormData data;

    QuerySnapshot snapShot = await formDataCollection.get();
    snapShot.docs;

    return snapShot.docs.map((doc) => FormData.fromJson(doc.data())).toList();
  }

  @override
  Future updateData(String id, String key, String value) {
    formDataCollection.doc(id).update({key:value});
  }


}