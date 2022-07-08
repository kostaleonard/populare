//Tests chat_post.dart.

import 'package:flutter_test/flutter_test.dart';
import 'package:populare/chat_post.dart';

void main() {
  test('Chat post has expected attributes', () {
    final post =
        ChatPost(id: 1, text: 'text', author: 'author', createdAt: DateTime(2022));
    expect(post.id, equals(1));
    expect(post.text, equals('text'));
    expect(post.author, equals('author'));
    expect(post.createdAt, equals(DateTime(2022)));
  });
}
