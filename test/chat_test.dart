//Tests chat.dart.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:populare/chat.dart';

void main() {
  testWidgets('Chat widget has a text box', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ChatWidget()));
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('Chat widget displays new message', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ChatWidget()));
    await tester.enterText(find.byType(TextField), 'sample post');
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    expect(find.text('sample post'), findsOneWidget);
  });

  //TODO add test for pressing enter key also posting

  //TODO test that we dispose resources properly, e.g., disposing the text editing controller

  //TODO add tests for appending posts

  //TODO add test for displaying posts in the correct order
}
