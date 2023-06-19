import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:personal_chat_app/services/sharedpref.dart';
import 'package:personal_chat_app/services/socket_methods.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

final dio = Dio();
// String base = "";
PrefsService _prefsService = PrefsService();
// final SocketMethods _socketMethods = SocketMethods();
Future<String> register(String name, String email, String password) async {
  Map<String, dynamic> requestBody = {
    "name": name,
    "email": email,
    "password": password
  };

  try {
    final response = await dio.post("${base}/users/", data: requestBody);
    if (response.data["status"] == false) {
      log(response.data["error"]);
      return response.data["error"];
    }
    return "created";
  } catch (e) {
    log(e.toString());
  }
  return "";
}

Future<String> login(String name, String pass) async {
  // final SharedPreferences prefs = await SharedPreferences.getInstance();

  Map<String, dynamic> requestBody = {"name": name, "password": pass};
  try {
    var url = "${base}/users/login";
    log("url is $url");
    final response = await dio.post(url, data: requestBody);
    _prefsService.creatCache([
      response.data["user"]["_id"],
      response.data["user"]["name"],
      response.data["user"]["email"]
    ]);
    log(response.data["user"].toString());
    return "success";
  } catch (e) {
    log(e.toString());
  }
  return "error";
}

//to get all the registered users
Future getall() async {
  try {
    final response = await dio.get("${base}/users/all/:id");
    log(response.data.toString());
    return response.data["users"];
  } catch (e) {
    log(e.toString());
  }
}

// Future sendmessage(String sender, String receiver, String messsage) async {
//   // log("sending message");
//   // Map<String, String> m = {
//   //   "sender": sender,
//   //   "receiver": receiver,
//   //   "message": messsage
//   // };
//   try {
//     // final response =
//     //     await dio.post("${base}/messages/addmessage", data: m);
//     // _socketMethods.sendmessage(sender, receiver, messsage);
//     log("success");
//     // log(response.data.toString());
//     // return response.data["users"];
//   } catch (e) {
//     log(e.toString());
//   }
// }
