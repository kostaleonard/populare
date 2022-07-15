//Tests chat.dart.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:populare/chat.dart';
import 'mock_chat_repository.dart';

void main() {
  testWidgets('Chat widget has one text box', (WidgetTester tester) async {
    final chatRepository = MockChatRepository();
    await tester.pumpWidget(
        MaterialApp(home: ChatWidget(chatRepository: chatRepository)));
    await tester.pump();
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('Pressing send button displays new message',
      (WidgetTester tester) async {
    final chatRepository = MockChatRepository();
    await tester.pumpWidget(
        MaterialApp(home: ChatWidget(chatRepository: chatRepository)));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'sample post');
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    final textFind = find.text('sample post');
    expect(textFind, findsOneWidget);
    expect(tester.firstWidget(textFind), isA<Text>());
  });

  testWidgets('Pressing send button clears text field',
      (WidgetTester tester) async {
    final chatRepository = MockChatRepository();
    await tester.pumpWidget(
        MaterialApp(home: ChatWidget(chatRepository: chatRepository)));
    await tester.pump();
    final textFieldFind = find.byType(TextField);
    await tester.enterText(textFieldFind, 'sample post');
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    final TextField textField = tester.firstWidget(textFieldFind);
    expect(textField.controller?.text, isEmpty);
  });

  testWidgets('Pressing enter displays new message',
      (WidgetTester tester) async {
    final chatRepository = MockChatRepository();
    await tester.pumpWidget(
        MaterialApp(home: ChatWidget(chatRepository: chatRepository)));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'sample post');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    final textFind = find.text('sample post');
    expect(textFind, findsOneWidget);
    expect(tester.firstWidget(textFind), isA<Text>());
  });

  testWidgets('Pressing enter clears text field', (WidgetTester tester) async {
    final chatRepository = MockChatRepository();
    await tester.pumpWidget(
        MaterialApp(home: ChatWidget(chatRepository: chatRepository)));
    await tester.pump();
    final textFieldFind = find.byType(TextField);
    await tester.enterText(textFieldFind, 'sample post');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    final TextField textField = tester.firstWidget(textFieldFind);
    expect(textField.controller?.text, isEmpty);
  });

  testWidgets('Posts are displayed with most recent at the bottom',
      (WidgetTester tester) async {
    final chatRepository = MockChatRepository();
    await tester.pumpWidget(
        MaterialApp(home: ChatWidget(chatRepository: chatRepository)));
    await tester.pump();
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
    final chatRepository = MockChatRepository();
    await tester.pumpWidget(
        MaterialApp(home: ChatWidget(chatRepository: chatRepository)));
    await tester.pump();
    await tester.enterText(find.byType(TextField), ' ');
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    await tester.enterText(find.byType(TextField), '\t');
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    expect(find.byType(ListTile), findsNothing);
  });

  // testWidgets('Pressing submit button scrolls to bottom of feed',
  //         (WidgetTester tester) async {
  //       final chatRepository = MockChatRepository();
  //       await tester.pumpWidget(
  //           MaterialApp(home: ChatWidget(chatRepository: chatRepository)));
  //       await tester.pump();
  //       //Add many posts.
  //       for (var idx = 0; idx < 5; idx++) {
  //         await tester.enterText(find.byType(TextField), 'text$idx');
  //         await tester.tap(find.byType(FloatingActionButton));
  //         await tester.pump();
  //       }
  //       //Scroll to the top.
  //       final listFinder = find.byType(Scrollable);
  //       await tester.scrollUntilVisible(find.text('text0'), 500.0, scrollable: listFinder);
  //       //Post again.
  //       await tester.enterText(find.byType(TextField), 'text100');
  //       await tester.tap(find.byType(FloatingActionButton));
  //       await tester.pump();
  //       //Check that the post is visible.
  //       final ListView listView = tester.firstWidget(find.byType(ListView));
  //       expect(listView.controller?.offset, 0);
  //     });
}
