import 'dart:async';
import 'package:chat_example/config/constant.dart';
import 'package:chat_example/config/enum.dart';
import 'package:chat_example/features/chat/entity/socketMessage.dart';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  IOWebSocketChannel? channel;
  final String channelUrl;
  WebSocketService(this.channelUrl);
  final StreamController<SocketMessage> streamController = StreamController.broadcast();

  Stream<SocketMessage> connect() {
    try {
      channel = IOWebSocketChannel.connect(Uri.parse(channelUrl));
      bool errorOccured = false;
      //Added delay to make sure no error has occured
      Future.delayed(
        const Duration(seconds: 3),
        () {
          if (!errorOccured) {
            streamController.add(
              SocketMessage(connectionState: ConnectionState.connected, message: 'Connected'),
            );
          }
        },
      );
      channel!.stream.listen((data) {
        streamController.add(
          SocketMessage(connectionState: ConnectionState.event, message: 'Response: $data'),
        );
      }, onError: (e) {
        errorOccured = true;
        streamController.add(
          SocketMessage(connectionState: ConnectionState.error, message: e.toString()),
        );
      }, onDone: () {
        channel = null;
        if (!errorOccured) {
          errorOccured = true;
          streamController.add(
            SocketMessage(connectionState: ConnectionState.disconnected, message: 'Disconnected'),
          );
        }
      });

      return streamController.stream;
    } on WebSocketChannelException catch (e) {
      rethrow;
    } catch (e) {
      //
      rethrow;
    }
  }

  //   ///Handling events of socket
  //   ///[chatMessageEvent] => event of message from backend, Rest are socket_io events for different states
  void _handlingData(dynamic event, dynamic data) {
    //   switch (event) {
    //     case 'connect':
    //       {
    //         streamController.add(
    //           SocketMessage(connectionState: ConnectionState.connected, message: 'Connected'),
    //         );
    //         break;
    //       }
    //     case 'connect_error':
    //     case 'connect_timeout':
    //     case 'error':
    //     case 'reconnect_failed':
    //     case 'reconnect_error':
    //       streamController.addError(data.toString());
    //       break;
    //     case 'connecting':
    //     case 'reconnect':
    //     case 'reconnecting':
    //       streamController.add(
    //         SocketMessage(connectionState: ConnectionState.connecting, message: data.toString()),
    //       );
    //       break;
    //     case 'disconnect':
    //       streamController.add(
    //         SocketMessage(connectionState: ConnectionState.disconnected, message: data.toString()),
    //       );
    //       break;
    //     case chatMessageEvent:
    //       streamController.add(
    //         SocketMessage(connectionState: ConnectionState.event, message: data.toString()),
    //       );
    //       break;

    //     default:
    //       break;
    //   }
  }
  sendMessage(dynamic data) {
    try {
      if (validateIfChannelIsInitialized()) {
        channel!.sink.add(data.toString());
        streamController.add(SocketMessage(connectionState: ConnectionState.event, message: 'Sent: $data'));
      }
      // socket.emit(chatMessageEvent, data);
    } catch (e) {
      rethrow;
    }
  }

  disconnect() {
    try {
      if (validateIfChannelIsInitialized()) {
        channel!.sink.close();
        streamController.add(SocketMessage(connectionState: ConnectionState.disconnected, message: 'Disconnected'));
      }
      // socket.disconnect();
    } catch (e) {
      rethrow;
    }
  }

  bool validateIfChannelIsInitialized() {
    if (!isChannelInitialized) {
      throw ('Channel is not initialized or disconnected, connect before further processing');
    }
    return true;
  }

  bool get isChannelInitialized => channel != null;
  bool get isChannelClosed => channel != null && channel!.closeCode != null;
}
