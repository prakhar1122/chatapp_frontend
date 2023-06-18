import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class StreamManager {
  var logger = Logger();
  final StreamController<List<dynamic>> _controller =
      StreamController<List<dynamic>>();
  StreamController<List<dynamic>> get controller => _controller;
  final dio = Dio();
  Future getallmessage(String sender, String receiver) async {
    log("getting ,messages and sender is $sender");
    Map<String, String> m = {"sender": sender, "receiver": receiver};
    try {
      final response = await dio
          .post("http://192.168.1.39:4000/messages/getmessage", data: m);
      List<dynamic> newData = response.data;
      _controller.sink.add(newData);
      // logger.d(_controller.stream);
      // logger.d(response.data);
      logger.d(response.data.length);
    } catch (e) {
      log(e.toString());
    }
  }

  void dispose() {
    _controller.close();
  }
}
