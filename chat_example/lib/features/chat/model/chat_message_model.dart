import 'package:chat_example/config/enum.dart';
import 'package:chat_example/features/chat/entity/chat_message.dart';
import 'package:chat_example/service/websocket.dart';

class ChatMessageModel {
  List<ChatMessage> chatMessage = [];

  ConnectionState connectionState = ConnectionState.connecting;

  updateConnectionState(ConnectionState connectionState) {
    this.connectionState = connectionState;
  }

  addMessage(ChatMessage message) {
    chatMessage.add(message);
  }
}
