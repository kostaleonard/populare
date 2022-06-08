//Tests chat_post.dart.

import 'package:flutter_test/flutter_test.dart';
import 'package:populare/chat_post.dart';

void main() {
  test('Chat post has expected attributes', () {
    final post =
        ChatPost(text: 'text', author: 'author', createdAt: DateTime(2022));
    expect(post.text, equals('text'));
    expect(post.author, equals('author'));
    expect(post.createdAt, equals(DateTime(2022)));
  });

  test('Chat post created without DateTime uses current time', () {
    DateTime start = DateTime.now();
    final post = ChatPost(text: 'text', author: 'author');
    DateTime end = DateTime.now();
    expect(start.isBefore(post.createdAt), true);
    expect(post.createdAt.isBefore(end), true);
  });

  test('Chat post created without author uses anonymous handle', () {
    final post = ChatPost(text: 'text');
    expect(post.author, equals(ChatPost.anonymousAuthor));
  });
}
