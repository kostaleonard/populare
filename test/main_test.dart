//Tests main.dart.

import 'package:flutter_test/flutter_test.dart';
import 'package:populare/main.dart';

void main() {
  testWidgets('My app has a title', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    expect(find.text('Startup name generator'), findsOneWidget);
  });
}
