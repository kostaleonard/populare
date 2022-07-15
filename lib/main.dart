//Runs the app.

import 'package:flutter/material.dart';
import 'package:populare/chat.dart';
import 'package:populare/local_chat_repository.dart';

void main() {
  //TODO switch this on for local deployment
  //runApp(PopulareApp(chatWidget: ChatWidget(chatRepository: LocalChatRepository())));
  runApp(PopulareApp());
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
