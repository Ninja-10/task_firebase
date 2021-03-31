import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:task_offline/bloc/authentication/authentication_bloc.dart';
import 'package:task_offline/bloc/connectivitybloc/connectivity_bloc.dart';
import 'package:task_offline/bloc/data/data_bloc.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebaseStorage;
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:path/path.dart' as Path;
import 'package:task_offline/services/locator.dart';
import 'package:task_offline/services/preference_manager.dart';
import 'package:uuid/uuid.dart';

class DataFormView extends StatefulWidget {
  static String id = "DataFormView";

  @override
  _DataFormViewState createState() => _DataFormViewState();
}

class _DataFormViewState extends State<DataFormView> {
  String phoneNumber, name;
  double lat, lng;
  firebaseStorage.UploadTask uploadTask;
  String imageUrl;

  File _image;
  String _uploadedFileURL;
  Position position;
  String uniqueId;

  var uuid = Uuid();

  @override
  void initState() {
    super.initState();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<DataBloc, DataState>(
        listener: (context, state) {
          if (state is DataSubmittedSuccessfully) {
            Scaffold.of(context).showSnackBar(
                SnackBar(content: Text("Data addedd successfuly")));
            if (context.read<ConnectivityBloc>().state.connected) {
              // FirebaseFirestore.instance.terminate();
              // FirebaseFirestore.instance.clearPersistence();
            } else {
              locator<PreferenceManager>().savePath(_image.path);
            }
          } else if (state is DataFailed) {
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: BlocBuilder<DataBloc, DataState>(builder: (context, state) {
          if (state is DataLoading) {
            return Center(child: CircularProgressIndicator());
          }

          return Container(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Form(
              child: Column(
                children: [
                  BlocBuilder<AuthenticationBloc, AuthenticationState>(
                      builder: (context, state) {
                    if (state is AuthenticationSuccess) {
                      phoneNumber = state.phoneNumber;
                      return TextFormField(
                        enabled: false,
                        initialValue: state.phoneNumber,
                        decoration: InputDecoration(labelText: "Phone Number"),
                        onChanged: (value) {
                          phoneNumber = state.phoneNumber;
                        },
                        validator: (value) {
                          if (value.length != 10) {
                            return "Not a valid number";
                          }
                          return null;
                        },
                      );
                    }
                  }),
                  TextFormField(
                    decoration: InputDecoration(labelText: "name"),
                    onChanged: (value) {
                      name = value;
                    },
                    validator: (value) {
                      if (value.length == 0) {
                        return "Not a valid number";
                      }
                      return null;
                    },
                  ),
                  Text('Selected Image'),
                  // _image != null
                  //     ? Image.file(
                  //         _image,
                  //         // height: 150,
                  //       )
                  //     : Container(height: 150),
                  _uploadedFileURL != null
                      ? Image.network(
                          _uploadedFileURL,
                          height: 100.0,
                        )
                      : _image != null
                          ? CircularProgressIndicator()
                          : Container(),
                  _image == null
                      ? RaisedButton(
                          child: Text('Choose File'),
                          onPressed: chooseFile,
                          color: Colors.cyan,
                        )
                      : Container(),
                  _image != null
                      ? _uploadedFileURL != null
                          ? Container()
                          : RaisedButton(
                              child: Text('Upload File'),
                              onPressed: uploadFile,
                              color: Colors.cyan,
                            )
                      : Container(),
                  ElevatedButton(
                      onPressed: () async {
                        position = await _determinePosition();
                        lat = position.latitude;
                        lng = position.longitude;
                        print(lat);
                        print(name);
                        print(_uploadedFileURL);
                        uniqueId = uuid.v1();
                        context.read<DataBloc>().add(DataSubmit(
                            phoneNumber: phoneNumber,
                            lat: lat,
                            lng: lng,
                            imageUrl: _uploadedFileURL,
                            name: name,
                            uuid: uniqueId));
                      },
                      child: Text("Submit"))
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Future chooseFile() async {
    await ImagePicker.platform
        .pickImage(source: ImageSource.camera)
        .then((image) {
      setState(() {
        _image = File(image.path);
        print("#########################################>");
        print(_image.path);
      });
    });
  }

  Future uploadFile() async {
    print(context.read<ConnectivityBloc>().state.connected);
    if (context.read<ConnectivityBloc>().state.connected) {
      firebaseStorage.Reference storageReference = firebaseStorage
          .FirebaseStorage.instance
          .ref()
          .child('images/${Path.basename(_image.path)}}');
      uploadTask = storageReference.putFile(_image);
      await uploadTask.whenComplete(() {
        print('File Uploaded');
        storageReference.getDownloadURL().then((fileURL) {
          setState(() {
            _uploadedFileURL = fileURL;
            print(_uploadedFileURL);
          });
        });
      });
    }
  }
}
