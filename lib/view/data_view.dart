import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_offline/bloc/connectivitybloc/connectivity_bloc.dart';
import 'package:task_offline/bloc/data/data_bloc.dart';
import 'package:task_offline/services/locator.dart';
import 'package:task_offline/services/preference_manager.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebaseStorage;
import 'package:path/path.dart' as Path;

class DataView extends StatefulWidget {
  static String id = "DataView";
  @override
  _DataViewState createState() => _DataViewState();
}

class _DataViewState extends State<DataView> {
  @override
  void initState() {
    // TODO: implement initState
    getUpdateData();
    context.read<DataBloc>().add(DataFetch());
    super.initState();
  }

  getUpdateData() async {
    String path = await locator<PreferenceManager>().getPath() ?? null;
    if (path != null && context.read<ConnectivityBloc>().state.connected) {
      await uploadFile(path);

      // QuerySnapshot data = await FirebaseFirestore.instance
      //   .collection("form_data")
      //   .get(GetOptions(source: Source.cache));
      // for (var doc in data.docs) {
      //   print(doc.id);
      // }

      // FirebaseFirestore.instance.doc(id).update({"imageUrl":absPath});
    }
  }

uploadFile(String path) async {
    String url;
    firebaseStorage.Reference storageReference = firebaseStorage
        .FirebaseStorage.instance
        .ref()
        .child('images/${Path.basename(path)}}');

    firebaseStorage.UploadTask uploadTask =
        storageReference.putFile(File(path));

    await uploadTask.whenComplete(() async {
      print('File Uploaded');
      var absPath = await storageReference.getDownloadURL();
      locator<PreferenceManager>().clear();
      var id;
      QuerySnapshot data = await FirebaseFirestore.instance
          .collection("form_data")
          .get(GetOptions(source: Source.cache));
      for (var doc in data.docs) {
        print(doc.id);
        id = doc.id;
      }
      print(id);
      await FirebaseFirestore.instance.collection("form_data").doc(id).update({"imageUrl":absPath});
    });

      await FirebaseFirestore.instance.terminate();
      await FirebaseFirestore.instance.clearPersistence();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataBloc, DataState>(builder: (context, state) {
      if (state is DataFetched) {
        return Scaffold(
            body: ListView.builder(
                itemCount: state.data.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Column(children: [
                        Text('Phone NUmber : ${state.data[index].phoneNumber}'),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text('Name : ${state.data[index].name}'),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text('Latitude : ${state.data[index].lat.toString()}'),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text('Longitude : ${state.data[index].lng.toString()}'),
                        SizedBox(
                          height: 10.0,
                        ),
                        state.data[index].imageUrl != null?Container(
                          child: Image.network(state.data[index].imageUrl,height: 100.0,),
                        ) :SizedBox(),
                      ]),
                    ),
                  );
                }));
      }

      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    });
  }
}
