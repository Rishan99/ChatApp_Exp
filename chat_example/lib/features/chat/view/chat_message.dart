import 'package:chat_example/config/enum.dart';
import 'package:chat_example/dependencies.dart';
import 'package:chat_example/features/chat/entity/chat_message.dart';
import 'package:chat_example/features/chat/model/chat_message_model.dart';
import 'package:chat_example/features/chat/provider/chat_message_view_model.dart';
import 'package:chat_example/features/chat/widgets/chat_bubble_widget.dart';
import 'package:chat_example/service/websocket.dart';
import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatProvider = ChangeNotifierProvider<ChatViewModel>((ref) {
  return getIt<ChatViewModel>();
});

class ChatMessagePage extends ConsumerWidget {
  ChatMessagePage({super.key});
  final EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 12);
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatProviderModel = ref.watch<ChatViewModel>(chatProvider);
    final data = chatProviderModel.chatMessageModel;
    final sortedChatMessage = data.chatMessage.reversed.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Message Me'),
        actions: [
          IconButton(
              onPressed: () {
                try {
                  chatProviderModel.disconnect();
                } catch (e) {
                  debugPrint(e.toString());
                }
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: padding,
            child: Column(
              children: [
                Expanded(
                  child: sortedChatMessage.isEmpty
                      ? const Center(child: Text('No Message Found'))
                      : ListView.separated(
                          reverse: true,
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
                          ),
                          itemBuilder: (context, index) {
                            return ChatBubbleWidget(chatMessage: sortedChatMessage[index]);
                          },
                          itemCount: sortedChatMessage.length,
                        ),
                ),
                chatBoxView(context, ref)
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: getHeaderWidget(data),
          ),
        ],
      ),
    );
  }

  Widget chatBoxView(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.white,
      constraints: BoxConstraints(minHeight: kBottomNavigationBarHeight + MediaQuery.of(context).viewPadding.bottom),
      child: Padding(
        padding: EdgeInsets.only(right: 8, bottom: MediaQuery.of(context).viewPadding.bottom),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                minLines: 1,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Type your message here...',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                ),
                controller: textEditingController,
                onTap: () {},
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Material(
                color: Colors.transparent,
                child: IconButton(
                    tooltip: 'Send',
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      try {
                        ref.read(chatProvider.notifier).sendMessage(textEditingController.text);
                        textEditingController.clear();
                      } catch (e) {
                        debugPrint(e.toString());
                      }
                    },
                    icon: const Icon(Icons.send)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getHeaderWidget(ChatMessageModel data) {
    Color backgroundColor = Colors.blue;
    String text = '';
    switch (data.connectionState) {
      case ConnectionState.connecting:
        backgroundColor = Colors.yellow;
        text = 'Connecting';
        break;
      case ConnectionState.connected:
        backgroundColor = Colors.blue;
        text = 'Connected';
        break;
      case ConnectionState.disconnected:
        backgroundColor = Colors.orange;
        text = 'Disconnected';
        break;
      case ConnectionState.error:
        backgroundColor = Colors.red;
        text = 'Error';
        break;
      default:
    }
    return Container(
      height: 25,
      width: double.maxFinite,
      color: backgroundColor,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
      ),
    );
  }
}
