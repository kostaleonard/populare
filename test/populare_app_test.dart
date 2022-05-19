//Tests populare_app.dart.

import 'package:flutter_test/flutter_test.dart';
import 'package:populare/populare_app.dart';

void main() {
  testWidgets('App has a title', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PopulareApp());
    expect(find.text('Startup name generator'), findsOneWidget);
  });
}
