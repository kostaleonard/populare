//Tests chat.dart.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:populare/chat.dart';

void main() {
  testWidgets('Chat widget has one text box', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ChatWidget()));
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('Pressing send button displays new message',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ChatWidget()));
    await tester.enterText(find.byType(TextField), 'sample post');
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    final textFind = find.text('sample post');
    expect(textFind, findsOneWidget);
    expect(tester.firstWidget(textFind), isA<Text>());
  });

  testWidgets('Pressing send button clears text field',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ChatWidget()));
    final textFieldFind = find.byType(TextField);
    await tester.enterText(textFieldFind, 'sample post');
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    final TextField textField = tester.firstWidget(textFieldFind);
    expect(textField.controller?.text, isEmpty);
  });

  testWidgets('Pressing enter displays new message',
      (WidgetTester tester) async {
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

  testWidgets('Posts are displayed with most recent at the bottom',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ChatWidget()));
    await tester.enterText(find.byType(TextField), 'first post');
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'second post');
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    final firstPostCenter = tester.getCenter(find.text('first post'));
    final secondPostCenter = tester.getCenter(find.text('second post'));
    expect(firstPostCenter.dy, lessThan(secondPostCenter.dy));
  });

  testWidgets('Whitespace only posts are not submitted',
          (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: ChatWidget()));
        await tester.enterText(find.byType(TextField), ' ');
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pump();
        await tester.enterText(find.byType(TextField), '\t');
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pump();
        expect(find.byType(ListTile), findsNothing);
      });
}
