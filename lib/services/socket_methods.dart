// import 'dart:developer';

// import 'package:personal_chat_app/services/socket_client.dart';
// import 'package:personal_chat_app/services/streams.dart';
// import 'package:socket_io_client/socket_io_client.dart';

// class SocketMethods {
//   final _socketClient = SocketClient.instance.socket!;
//   final StreamManager _streamManager = StreamManager();
//   Socket get socketClient => _socketClient;
//   void disconnectSocket() {
//     _socketClient.disconnect();
//   }

//   //emitters
//   void joinsocket(String user) {
//     if (user.isNotEmpty) {
//       _socketClient.emit("add", {"user": user});
//     }
//   }

//   void sendmessage(String sender, String receiver, String msg) {
//     log("fa");
//     _socketClient
//         .emit("send", {"sender": sender, "receiver": receiver, "message": msg});
//   }

//   //listeners

//   void onReceiveListener(String sender, String receiver) {
//     _socketClient.on("received", (data) {
//       log("got message");
//       _streamManager.getallmessage(sender, receiver);
//     });
//   }
// }
