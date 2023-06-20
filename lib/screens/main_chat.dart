// import 'dart:async';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
// import 'package:chatproject/colors.dart';
// import 'package:chatproject/constants.dart';
// import 'package:chatproject/resources/socket_methods.dart';
// import 'package:chatproject/screens/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:personal_chat_app/models/msgmodel.dart';
import 'package:personal_chat_app/provider/userdata.dart';
import 'package:personal_chat_app/services/api_services.dart';
import 'package:personal_chat_app/services/socket_methods.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:logger/logger.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:socket_io_client/socket_io_client.dart';

// import 'package:socket_io_client/socket_io_client.dart' as io;
import 'dart:developer';

import '../colors.dart';
import '../services/sharedpref.dart';
import '../services/socket_client.dart';
import '../services/streams.dart';
// import 'package:file_picker/file_picker.dart';

class Mainchat extends StatefulWidget {
  final String receiver;
  final String image;

  const Mainchat({required this.receiver, required this.image});

  @override
  State<Mainchat> createState() => _MainchatState();
}

class _MainchatState extends State<Mainchat> with WidgetsBindingObserver {
  late String userid;
  final TextEditingController _controller = TextEditingController();
  ScrollController messageController = ScrollController();
  final StreamManager _streamManager = StreamManager();
  List<MsgModel> messages = [];
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  // PrefsService _prefsService = PrefsService();
  // final SocketMethods _socketMethods = SocketMethods();
  // late List<String> cache;
  // void getdata() async {
  //   cache = await _prefsService.getCache();
  //   log(cache.toString());
  //   log(cache.length.toString());
  // }

  final _socketClient = SocketClient.instance.socket!;
  void disconnectSocket(String user) {
    _socketClient.emit("dconnect", {"user": user});
    _socketClient.close();
    if (_socketClient.connected) {
      log('Socket is connected');
    } else {
      log('Socket is not connected');
    }
  }

  //emitters
  void joinsocket(String user) {
    if (user.isNotEmpty) {
      log("joining socket");
      _socketClient.emit("add", {"user": user});
    }
  }

  Future sendmessage(String sender, String receiver, String msg) async {
    log("fa");
    _socketClient
        .emit("send", {"sender": sender, "receiver": receiver, "message": msg});
  }

  //listeners

  void onReceiveListener() {
    _socketClient.on("received", (data) {
      log("got message");
      _streamManager.getallmessage(UserData.cache[1], widget.receiver);
    });
  }

  // void openAudio() async {
  //   final status = await Permission.microphone.request();
  //   if (status != PermissionStatus.granted) {
  //     throw RecordingPermissionException("mic permission not allowed!");
  //   }
  //   await _soundRecorder!.openRecorder();
  //   isRecorderInit = true;
  // }

  @override
  void initState() {
    super.initState();
    _streamManager.getallmessage(UserData.cache[1], widget.receiver);
    joinsocket(UserData.cache[1]);
    onReceiveListener();
  }

  @override
  void dispose() {
    // disconnectSocket(UserData.cache[1]);
    messageController.dispose();
    _streamManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final safeArea = MediaQuery.of(context).padding;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight =
        MediaQuery.of(context).size.height - safeArea.top - safeArea.bottom;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: primary2,
        leadingWidth: 200,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back,
                size: 30,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              widget.receiver,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 20),
            )
          ],
        ),
      ),
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height - 100,
            child: StreamBuilder(
              stream: _streamManager.controller.stream,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                  messageController
                      .jumpTo(messageController.position.maxScrollExtent);
                });
                return ListView.builder(
                    controller: messageController,
                    itemCount: snapshot.data.length + 1,
                    itemBuilder: (context, index) {
                      if (index == snapshot.data.length) {
                        return Container(
                          height: 40,
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                                  snapshot.data[index]["fromself"] == true
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                              children: [
                                BubbleSpecialOne(
                                  isSender:
                                      snapshot.data[index]["fromself"] == true
                                          ? true
                                          : false,
                                  text: snapshot.data[index]["message"],
                                  tail: true,
                                  color:
                                      snapshot.data[index]["fromself"] == true
                                          ? primary
                                          : Color(0xffefefef),
                                  textStyle: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300,
                                    color:
                                        snapshot.data[index]["fromself"] == true
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment:
                                  snapshot.data[index]["fromself"] == true
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: Text(
                                    "${24 - snapshot.data[index]["hour"]}:${snapshot.data[index]["minutes"]}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    });
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 60,
              width: screenWidth,
              color: Colors.white,
              child: Card(
                color: primary2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      width: screenWidth - 80,
                      child: TextField(
                        style: TextStyle(
                          color: Colors
                              .white, // Set the desired color for the input text
                        ),
                        controller: _controller,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                          border: InputBorder.none,
                          hintText: "tap to send message",
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_controller.text.isNotEmpty) {
                          sendmessage(UserData.cache[1], widget.receiver,
                              _controller.text);
                          _streamManager.getallmessage(
                              UserData.cache[1], widget.receiver);
                          _controller.clear();
                        }
                      },
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Color.fromRGBO(46, 43, 208, 1),
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
