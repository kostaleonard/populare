//Runs the app.

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:populare/chat.dart';
import 'package:populare/chat_repository.dart';

void main() {
  print('Starting up populare app (stdout)');
  print('dbProxyUri is http://192.168.64.3:30120/db-proxy');
  print('base: ${Uri.base.authority}');
  log('Starting up populare app');
  //runApp(PopulareApp(chatWidget: ChatWidget(chatRepository: ChatRepository(dbProxyUri: 'http://192.168.64.3:30120/db-proxy'))));
  runApp(PopulareApp(chatWidget: ChatWidget(chatRepository: ChatRepository(dbProxyUri: 'http://${Uri.base.authority}/db-proxy'))));
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
