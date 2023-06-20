import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  Future creatCache(List<String> list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("userdata", list);
  }

  Future getCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cache = prefs.getStringList("userdata");

    return cache;
  }

  Future deleteCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("userdata");
  }
}
