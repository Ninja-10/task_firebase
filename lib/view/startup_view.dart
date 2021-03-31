import 'package:flutter/material.dart';

class StartupView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Container(
        child: Center(
          child: Text("Loading...",style: TextStyle(
            fontSize: 40.0
          ),),
        ),
      ),
    );
  }
}