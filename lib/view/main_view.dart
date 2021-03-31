import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_offline/bloc/authentication/authentication_bloc.dart';
import 'package:task_offline/services/locator.dart';
import 'package:task_offline/services/navigation_services.dart';
import 'package:task_offline/services/preference_manager.dart';
import 'package:task_offline/view/data_form_view.dart';
import 'package:task_offline/view/data_view.dart';

class MainView extends StatelessWidget {
  static String id = "MainView";


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      if (state is AuthenticationSuccess) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Home Screen"),
          ),
          drawer: Drawer(
            child: ListView(
              children: [
                ListTile(
                  title: Text("View Data"),
                  onTap: () {
                    Navigator.pop(context);
                    locator<NavigationService>()
                        .goAndComeBack(DataView(), DataView.id);
                  },
                ),
                ListTile(
                  title: Text("Add data"),
                  onTap: () {
                    Navigator.pop(context);
                    locator<NavigationService>()
                        .goAndComeBack(DataFormView(), DataFormView.id);
                  },
                ),
                ListTile(
                  title: Text("LogOut"),
                  onTap: () {
                    Navigator.pop(context);
                    showAlertDialog(context);
                  },
                ),
              ],
            ),
          ),
          body: Container(
            padding: EdgeInsets.only(top: 50.0),
            child: Center(
              child: Column(
                children: [
                  Text("uid : ${state.displayName}"),
                  SizedBox(height: 15.0),
                  Text("phone Number:${state.phoneNumber}")
                ],
              ),
            ),
          ),
        );
      }
    });
  }

  showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("Yes"),
      onPressed: () {
        Navigator.of(context).pop();
        context.read<AuthenticationBloc>().add(AuthenticationLoggedOut());
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Sign out"),
      content: Text("Are you sure you want signout?"),
      actions: [
        Row(
          children: [
            okButton,
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel"))
          ],
        )
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
