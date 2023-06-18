// import 'dart:async';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
// import 'package:chatproject/colors.dart';
// import 'package:chatproject/constants.dart';
// import 'package:chatproject/resources/socket_methods.dart';
// import 'package:chatproject/screens/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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

class _MainchatState extends State<Mainchat> {
  late String userid;
  TextEditingController _controller = TextEditingController();
  ScrollController messageController = ScrollController();
  final StreamManager _streamManager = StreamManager();
  // PrefsService _prefsService = PrefsService();
  // final SocketMethods _socketMethods = SocketMethods();
  // late List<String> cache;
  // void getdata() async {
  //   cache = await _prefsService.getCache();
  //   log(cache.toString());
  //   log(cache.length.toString());
  // }

  final _socketClient = SocketClient.instance.socket!;
  void disconnectSocket() {
    _socketClient.disconnect();
  }

  //emitters
  void joinsocket(String user) {
    if (user.isNotEmpty) {
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
    // TODO: implement dispose
    super.dispose();
    disconnectSocket();
    _streamManager.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final safeArea = MediaQuery.of(context).padding;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight =
        MediaQuery.of(context).size.height - safeArea.top - safeArea.bottom;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.chevron_left_rounded,
              color: Colors.black87,
              size: 30,
            ),
          ),
          centerTitle: true,
          title: Container(
            width: 140,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 22,
                  // minRadius: 10,
                  backgroundImage: NetworkImage("https://picsum.photos/200"),
                ),
                SizedBox(
                  width: 5,
                ),
                Container(
                  width: 85,
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    widget.receiver,
                    style: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  children: [
                    SizedBox(
                        height: screenHeight - 100,
                        child: StreamBuilder(
                          stream: _streamManager.controller.stream,
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }

                            SchedulerBinding.instance
                                .addPostFrameCallback((timeStamp) {
                              messageController.jumpTo(
                                  messageController.position.maxScrollExtent);
                            });
                            return ListView.builder(
                                controller: messageController,
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              snapshot.data[index]
                                                          ["fromself"] ==
                                                      true
                                                  ? MainAxisAlignment.end
                                                  : MainAxisAlignment.start,
                                          children: [
                                            BubbleSpecialOne(
                                              isSender: snapshot.data[index]
                                                          ["fromself"] ==
                                                      true
                                                  ? true
                                                  : false,
                                              text: snapshot.data[index]
                                                  ["message"],
                                              tail: true,
                                              color: snapshot.data[index]
                                                          ["fromself"] ==
                                                      true
                                                  ? primary
                                                  : Color(0xffefefef),
                                              textStyle: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w300,
                                                color: snapshot.data[index]
                                                            ["fromself"] ==
                                                        true
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              snapshot.data[index]
                                                          ["fromself"] ==
                                                      true
                                                  ? MainAxisAlignment.end
                                                  : MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15.0),
                                              child: Text(
                                                "2:30 pm",
                                                style: TextStyle(
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
                        )),
                    Container(
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  useSafeArea: true,
                                  backgroundColor: Color(0xfffafafa),
                                  context: context,
                                  constraints: BoxConstraints(
                                      maxWidth: screenWidth, maxHeight: 120),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  builder: (BuildContext context) {
                                    return Container(
                                      width: screenWidth / 2 + 10,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(100))),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Column(
                                              children: [
                                                CircleAvatar(
                                                    backgroundColor:
                                                        Color(0x965458ab),
                                                    radius: 25,
                                                    child: Icon(
                                                      Icons.photo_sharp,
                                                      color: Colors.white,
                                                    )),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text("Gallery")
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Column(
                                              children: [
                                                CircleAvatar(
                                                    backgroundColor:
                                                        Color(0x965458ab),
                                                    radius: 25,
                                                    child: Icon(
                                                      Icons.edit_document,
                                                      color: Colors.white,
                                                    )),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text("Document")
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Transform.rotate(
                                  angle: 90, child: Icon(Icons.attach_file)),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: screenWidth - 24 - 10 - 60 - 20,
                              child: TextField(
                                controller: _controller,
                                decoration: InputDecoration(
                                    hintText: 'Type message here',
                                    hintStyle: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w300),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                    )),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                log(_controller.text);
                                await sendmessage(UserData.cache[1],
                                    widget.receiver, _controller.text);
                                _streamManager.getallmessage(
                                    UserData.cache[1], widget.receiver);
                              },
                              child: const CircleAvatar(
                                backgroundColor:
                                    Color.fromRGBO(51, 48, 212, 1.0),
                                radius: 30,
                                child: Icon(
                                  Icons.send,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
