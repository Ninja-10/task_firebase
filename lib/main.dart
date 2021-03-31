import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_offline/bloc/connectivitybloc/connectivity_bloc.dart';
import 'package:task_offline/bloc/login/login_bloc.dart';
import 'package:task_offline/services/locator.dart';
import 'package:task_offline/services/navigation_services.dart';
import 'package:task_offline/view/Login_view.dart';
import 'package:task_offline/view/main_view.dart';
import 'package:task_offline/view/startup_view.dart';
import 'bloc/authentication/authentication_bloc.dart';
import 'package:task_offline/bloc/data/data_bloc.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  runApp(MultiBlocProvider(providers: [
     BlocProvider<ConnectivityBloc>(
        create: (BuildContext context) =>
            ConnectivityBloc()..add(ConnectivityLoad())),
    BlocProvider(create: (BuildContext context) => AuthenticationBloc()..add(AuthenticationStarted()) ),
    BlocProvider(create: (BuildContext context) => LoginBloc()..add(LoginStarted()) ),
    BlocProvider(create: (BuildContext context) => DataBloc()..add(DataStarted()) ),
  ], child: MyApp()));
}

// class Home extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return 
//     MaterialApp(
//       navigatorKey: locator<NavigationService>().navigationKey,
//       home: MyApp(),
//     );
//   }
// }


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: locator<NavigationService>().navigationKey,
      home: BlocListener<ConnectivityBloc, ConnectivityState>(
        listener: (context, connectionState) {
            if (!connectionState.connected) {
              print('connectivity : is not connected');
            } else {
              // ConnectionErrorDialog.hide(context);
            }
            print('connectivity : ${connectionState.connected}');
          },

          child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
            print('Authentication: $state');
            if (state is AuthenticationInitial) {
              return StartupView();
            } else if (state is AuthenticationSuccess) {
              return MainView();
            } else {
              return LoginView();
            }
          }),
      ),
    );
  }
}



/*
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String name;
  Size size;

  String host = defaultTargetPlatform == TargetPlatform.android
      ? '10.0.2.2:8080'
      : 'localhost:8080';

  @override
  void initState() {
    // getData();
    super.initState();
  }

  // Future<void> getData()async{
  //   FirebaseFirestore.instance.collection("users")
  // }

  Future<void> pushData(String name) async {
    // Set the host as soon as possible.
    FirebaseFirestore.instance.settings =
        Settings(host: host, sslEnabled: false);
    FirebaseFirestore.instance.settings = Settings(persistenceEnabled: true);
    try{
        var response = await FirebaseFirestore.instance.collection("users").add({
      "my_name": name,
    });
    print(response.id);
    }catch(e){
      throw Exception(e);
    }
    

    
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child:Form(
                child: Column(children: [
                  TextField(
                    onChanged: (value) {
                      name = value;
                    },
                  ),
                  SizedBox(),
                  ElevatedButton(
                      onPressed: () {
                        pushData(name);
                      },
                      child: Text("Submit")),
                  Container(
                    height: size.height/2,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text("Loading");
                        }

                        return new ListView(
                          children: snapshot.data.docs
                              .map((DocumentSnapshot document) {
                            return new ListTile(
                              title: new Text(document.data()['my_name']),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  )
                ]),
              ),
            ),
          ),
    );
  }
}

*/