import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManager{
  static const String ID ="id";
  static const String PATH = "path";
  static const String STATUS = "status";

  
  Future saveId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(ID, id);
  }

    Future<String> getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(ID);
  }

   Future savePath(String path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(PATH, path);
  }

    Future<String> getPath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(PATH);
  }


  Future saveIsOfflined(bool value)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(STATUS, value);
  }


  Future<bool> isOfflined() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(STATUS);
  }

  Future clear() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.clear();
  }



}

