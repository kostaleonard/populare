//Runs the app in local mode for demonstration purposes.

import 'package:flutter/material.dart';
import 'package:populare/chat.dart';
import 'package:populare/local_chat_repository.dart';

void main() {
  runApp(PopulareApp(
      chatWidget: ChatWidget(chatRepository: LocalChatRepository())));
}

class PopulareApp extends StatelessWidget {
  final ChatWidget chatWidget;

  PopulareApp({Key? key, ChatWidget? chatWidget})
      : chatWidget = chatWidget ?? ChatWidget(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Populare',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.indigo, foregroundColor: Colors.white),
        ),
        home: chatWidget);
  }
}
