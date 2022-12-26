import 'package:chat_example/config/constant.dart';
import 'package:chat_example/features/chat/model/chat_message_model.dart';
import 'package:chat_example/features/chat/provider/chat_message_view_model.dart';
import 'package:chat_example/service/websocket.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

setupDependencies() {
  getIt.registerSingleton<WebSocketService>(WebSocketService(websocketUrl));
  getIt.registerFactory<ChatViewModel>(() => ChatViewModel(getIt<WebSocketService>(), ChatMessageModel()));
}
