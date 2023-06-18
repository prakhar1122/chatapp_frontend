import 'dart:developer';

import 'package:flutter/material.dart';

import '../services/sharedpref.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final PrefsService _prefsService = PrefsService();
  late List<String> cache;
  void getdata() async {
    cache = await _prefsService.getCache();
    log(cache.toString());
    log(cache.length.toString());
  }

  // check() async {
  //   if()
  // }
  @override
  void initState() {
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
