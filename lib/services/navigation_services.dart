import 'package:flutter/material.dart';

class NavigationService{
  GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  Future goNoComeBack(Widget page, String name)async{
    await _navigationKey.currentState.pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => page, settings: RouteSettings(name: name)),
            (Route<dynamic> route) => false);
  }

  Future goAndComeBack(Widget page, String name) async {
    print("goAndComeBack: ${page.runtimeType.toString()}");
    var result = await _navigationKey.currentState.push(MaterialPageRoute(
        builder: (context) => page, settings: RouteSettings(name: name)));
    return result;
  }

  Future replace(Widget page, String name) async {
    var result = await _navigationKey.currentState.pushReplacement(
        MaterialPageRoute(
            builder: (context) => page, settings: RouteSettings(name: name)));
    return result;
  }

}