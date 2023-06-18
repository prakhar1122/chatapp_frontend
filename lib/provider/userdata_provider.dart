import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDataProvider extends ChangeNotifier {
  List<String> cache = [];

  List<String> get getUserData => cache;
  void setUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cache = prefs.getStringList("userdata")!;
  }
}
