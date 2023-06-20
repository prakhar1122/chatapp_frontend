import 'dart:developer';

import '../services/sharedpref.dart';

class UserData {
  static List<String> cache = [];
  final PrefsService _prefsService = PrefsService();

  Future getdata() async {
    var temp = await _prefsService.getCache();
    if (temp != null) cache = temp;
    log(cache.toString());
    log(cache.length.toString());
  }

  cleardata() async {
    _prefsService.deleteCache();
  }
}
