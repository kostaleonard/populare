//Tests chat.dart.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:populare/chat.dart';

void main() {
  testWidgets('Chat widget has a text box', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: ChatWidget()));
    expect(find.byType(TextField), findsOneWidget);
  });
}
