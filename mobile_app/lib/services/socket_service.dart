import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../models/tweet.dart';

class SocketService {
  static IO.Socket? _socket;
  static Function(Tweet)? _onNewTweet;

  static void init() {
    _socket = IO.io('http://20.193.143.179:5500', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    _socket!.onConnect((_) {
      print('Connected to socket server');
    });

    _socket!.on('newTweet', (data) {
      if (_onNewTweet != null) {
        final tweet = Tweet.fromJson(data);
        _onNewTweet!(tweet);
      }
    });

    _socket!.onDisconnect((_) {
      print('Disconnected from socket server');
    });

    _socket!.onError((error) {
      print('Socket error: $error');
    });
  }

  static void setOnNewTweetCallback(Function(Tweet) callback) {
    _onNewTweet = callback;
  }

  static void connect() {
    _socket?.connect();
  }

  static void disconnect() {
    _socket?.disconnect();
  }

  static void dispose() {
    _socket?.dispose();
    _socket = null;
    _onNewTweet = null;
  }
}
