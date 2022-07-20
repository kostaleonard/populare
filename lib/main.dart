//Runs the app.

import 'package:flutter/material.dart';
import 'package:populare/chat.dart';
import 'package:populare/chat_repository.dart';

void main() {
  runApp(PopulareApp(
      chatWidget: ChatWidget(
          chatRepository: ChatRepository(
              dbProxyUri: 'http://${Uri.base.authority}/db-proxy'))));
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
