import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../constants.dart';

class SocketClient {
  IO.Socket? socket;

  static SocketClient? _instance;

  SocketClient._internal() {
    socket = IO.io(base, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket!.connect();
  }
  static SocketClient get instance {
    _instance ??= SocketClient._internal();
    return _instance!;
  }
}
