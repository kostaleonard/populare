//Tests main.dart.

import 'package:flutter_test/flutter_test.dart';
import 'package:populare/local_chat_repository.dart';
import 'package:populare/chat.dart';
import 'package:populare/main.dart';

void main() {
  testWidgets('App has a title', (WidgetTester tester) async {
    final chatRepository = LocalChatRepository();
    final chatWidget = ChatWidget(chatRepository: chatRepository);
    await tester.pumpWidget(PopulareApp(chatWidget: chatWidget));
    expect(find.text('Chat with friends, Romans, countrymen'), findsOneWidget);
  });
}
