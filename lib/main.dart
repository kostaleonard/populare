//Runs the app.

import 'package:flutter/material.dart';
import 'package:populare/chat.dart';

void main() {
  runApp(const PopulareApp());
}

class PopulareApp extends StatelessWidget {
  const PopulareApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Populare',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.indigo, foregroundColor: Colors.white),
        ),
        home: const ChatWidget());
  }
}
