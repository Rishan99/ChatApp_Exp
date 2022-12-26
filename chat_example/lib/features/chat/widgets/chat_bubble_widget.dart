import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:chat_example/features/chat/entity/chat_message.dart';

class ChatBubbleWidget extends StatelessWidget {
  final ChatMessage chatMessage;
  const ChatBubbleWidget({
    Key? key,
    required this.chatMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      chatMessage.message,
      style: const TextStyle(fontSize: 15),
    );
  }
}
