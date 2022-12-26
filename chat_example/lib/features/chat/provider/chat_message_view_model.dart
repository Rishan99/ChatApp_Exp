import 'dart:async';

import 'package:chat_example/config/enum.dart';
import 'package:chat_example/features/chat/entity/socketMessage.dart';
import 'package:chat_example/features/chat/entity/chat_message.dart';
import 'package:chat_example/features/chat/model/chat_message_model.dart';
import 'package:chat_example/service/websocket.dart';
import 'package:flutter/cupertino.dart' hide ConnectionState;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/io.dart';

class ChatViewModel extends ChangeNotifier {
  final WebSocketService webSocket;
  final ChatMessageModel chatMessageModel;
  late Stream<SocketMessage> stream;
  ChatViewModel(this.webSocket, this.chatMessageModel) {
    startConnection();
  }
  startConnection() {
    try {
      stream = webSocket.connect();

      stream.listen((event) {
        switch (event.connectionState) {
          case ConnectionState.event:
            updateMessage(event.message.toString());
            break;
          default:
            chatMessageModel.updateConnectionState(event.connectionState);
            notifyListeners();
        }
      }).onError((handleError) {
        chatMessageModel.updateConnectionState(ConnectionState.error);
        notifyListeners();
      });
    } catch (e) {
      chatMessageModel.updateConnectionState(ConnectionState.error);
      notifyListeners();
    }
  }

  updateMessage(String message) {
    try {
      chatMessageModel.addMessage(ChatMessage(message: message));
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  sendMessage(String message) {
    try {
      if (webSocket.isChannelClosed) throw ('Connection is already closed');
      webSocket.sendMessage(message);
    } catch (e) {
      rethrow;
    }
  }

  disconnect() {
    try {
      if (webSocket.isChannelClosed) throw ('Connection is already closed');
      webSocket.disconnect();
    } catch (e) {
      rethrow;
    }
  }
}
