//Tests chat.dart.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:populare/chat.dart';

void main() {
  testWidgets('Chat widget has one text box', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ChatWidget()));
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('Pressing send button displays new message', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ChatWidget()));
    await tester.enterText(find.byType(TextField), 'sample post');
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    final textFind = find.text('sample post');
    expect(textFind, findsOneWidget);
    expect(tester.firstWidget(textFind), isA<Text>());
  });

  testWidgets('Pressing send button clears text field', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ChatWidget()));
    final textFieldFind = find.byType(TextField);
    await tester.enterText(textFieldFind, 'sample post');
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    final TextField textField = tester.firstWidget(textFieldFind);
    expect(textField.controller?.text, isEmpty);
  });

  testWidgets('Pressing enter displays new message', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ChatWidget()));
    await tester.enterText(find.byType(TextField), 'sample post');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    final textFind = find.text('sample post');
    expect(textFind, findsOneWidget);
    expect(tester.firstWidget(textFind), isA<Text>());
  });

  testWidgets('Pressing enter clears text field', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ChatWidget()));
    final textFieldFind = find.byType(TextField);
    await tester.enterText(textFieldFind, 'sample post');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    final TextField textField = tester.firstWidget(textFieldFind);
    expect(textField.controller?.text, isEmpty);
  });

  //TODO test that we dispose resources properly, e.g., disposing the text editing controller

  //TODO add tests for appending posts

  //TODO add test for displaying posts in the correct order
}
