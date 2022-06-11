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

  test('getDisplayDate returns expected format', () {
    //12:20:15.999 on January 2nd, 2022.
    final date = DateTime(2022, 1, 2, 12, 20, 15, 999);
    final post = ChatPost(text: 'text', createdAt: date);
    expect(post.getDisplayDate(), '12:20 on 2022-1-2');
  });

  test('getDisplayDate zero-pads minutes', () {
    //3:05:15.999 on January 2nd, 2022.
    final date = DateTime(2022, 1, 2, 3, 05, 15, 999);
    final post = ChatPost(text: 'text', createdAt: date);
    expect(post.getDisplayDate(), '3:05 on 2022-1-2');
  });

  test('getDisplayDate uses 24 hour time format', () {
    //14:20:15.999 on January 2nd, 2022.
    final date = DateTime(2022, 1, 2, 14, 20, 15, 999);
    final post = ChatPost(text: 'text', createdAt: date);
    expect(post.getDisplayDate(), '14:20 on 2022-1-2');
  });
}
