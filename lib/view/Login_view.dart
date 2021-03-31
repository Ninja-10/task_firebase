import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_offline/bloc/authentication/authentication_bloc.dart';
import 'package:task_offline/bloc/login/login_bloc.dart';
import 'package:task_offline/services/locator.dart';
import 'package:task_offline/services/navigation_services.dart';
import 'package:task_offline/view/main_view.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String phoneNumber, otp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context,state){
          if (state is OtpSent){
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("Otp send to your number"),
            ));
          }else if(state is LoginFailed){
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
            ));
          }else if(state is LoginSuccessFul){
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("Success"),
            ));
            context.read<AuthenticationBloc>().add(AuthenticationStarted());
            // locator<NavigationService>().goNoComeBack(MainView(), MainView.id);

          }else if(state is UserIsNotExists){
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("User not exist"),
            ));
          }else if(state is LoginSubmitting){
             Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("Loading...."),
            ));
          }
        },
        builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          margin: EdgeInsets.only(top: 150.0),
          child: SingleChildScrollView(
            child: Container(
              child: Form(
                child: Column(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: "Phone Number"),
                              onChanged: (value) {
                                phoneNumber = value;
                              },
                              validator: (value) {
                                if (value.length != 10) {
                                  return "Not a valid number";
                                }
                                return null;
                              },
                            ),
                          ),
                          Expanded(
                              child: ElevatedButton(
                                  onPressed: () {
                                    context.read<LoginBloc>().add(SendOtpEvent(phoneNumber: phoneNumber));
                                  },
                                  child: Icon(Icons.arrow_forward))),
                        ],
                      ),
                    ),
                    Container(
                      child: TextFormField(
                          decoration: InputDecoration(labelText: "Otp"),
                          onChanged: (value) {
                            otp = value;
                          },
                          validator: (value) {
                            if (value.length != 6) {
                              return "Not a valid otp";
                            }
                            return null;
                          }),
                    ),
                    Container(
                      child: ElevatedButton(
                          onPressed: () {
                                    context.read<LoginBloc>().add(SubmitOtpEvent(otp));

                          }, child: Text("Submit")),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
