import 'dart:developer';

import '../services/sharedpref.dart';

class UserData {
  static List<String> cache = [];
  PrefsService _prefsService = PrefsService();
  Future getdata() async {
    cache = await _prefsService.getCache();
    log(cache.toString());
    log(cache.length.toString());
  }
}
