//Runs the app.

import 'package:flutter/material.dart';
import 'package:populare/random_words.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Startup name generator',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.indigo, foregroundColor: Colors.white),
        ),
        home: const RandomWords());
  }
}
