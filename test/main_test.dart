//Tests main.dart.

import 'package:flutter_test/flutter_test.dart';
import 'package:populare/main.dart';

void main() {
  testWidgets('App has a title', (WidgetTester tester) async {
    await tester.pumpWidget(const PopulareApp());
    expect(find.text('Chat with friends, Romans, countrymen'), findsOneWidget);
  });
}