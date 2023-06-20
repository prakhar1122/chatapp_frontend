import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:personal_chat_app/provider/userdata.dart';
import 'package:personal_chat_app/screens/home_page.dart';
import 'package:personal_chat_app/screens/signup.dart';
import 'package:personal_chat_app/screens/welcone_screen.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../services/sharedpref.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final PrefsService _prefsService = PrefsService();
  // late List<String> cache;
  // void getdata() async {
  //   cache = await _prefsService.getCache();
  //   log(cache.toString());
  //   log(cache.length.toString());
  // }

  check() async {
    var cache = await _prefsService.getCache();
    await UserData().getdata();
    if (cache == null) {
      log("no user");
      return Timer(Duration(seconds: 1), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return const SignUp();
        }));
      });
    } else {
      log("existing user");

      return Timer(Duration(seconds: 1), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return const Home();
        }));
      });
    }
  }

  @override
  void initState() {
    check();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("checking"),
      ),
    );
  }
}
