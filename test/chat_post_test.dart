//Tests chat_post.dart.

import 'package:flutter_test/flutter_test.dart';
import 'package:populare/chat_post.dart';

void main() {
  test('Chat post has expected attributes', () {
    final post = ChatPost(
        id: 1, text: 'text', author: 'author', createdAt: DateTime(2022));
    expect(post.id, equals(1));
    expect(post.text, equals('text'));
    expect(post.author, equals('author'));
    expect(post.createdAt, equals(DateTime(2022)));
  });

  test('Chat post fromJSON constructor', () {
    final post = ChatPost.fromJSON({
      'id': 1,
      'text': 'text',
      'author': 'author',
      'created_at': '2022-01-01T00:00:00'
    });
    expect(post.id, equals(1));
    expect(post.text, equals('text'));
    expect(post.author, equals('author'));
    expect(post.createdAt, equals(DateTime(2022)));
  });

  test('getDisplayDate returns expected format', () {
    //12:20:15.999 on January 2nd, 2022.
    final date = DateTime(2022, 1, 2, 12, 20, 15, 999);
    final post =
        ChatPost(id: 1, text: 'text', author: 'author', createdAt: date);
    expect(post.getDisplayDate(), '12:20 on 2022-1-2');
  });

  test('getDisplayDate zero-pads minutes', () {
    //3:05:15.999 on January 2nd, 2022.
    final date = DateTime(2022, 1, 2, 3, 05, 15, 999);
    final post =
        ChatPost(id: 1, text: 'text', author: 'author', createdAt: date);
    expect(post.getDisplayDate(), '3:05 on 2022-1-2');
  });

  test('getDisplayDate uses 24 hour time format', () {
    //14:20:15.999 on January 2nd, 2022.
    final date = DateTime(2022, 1, 2, 14, 20, 15, 999);
    final post =
        ChatPost(id: 1, text: 'text', author: 'author', createdAt: date);
    expect(post.getDisplayDate(), '14:20 on 2022-1-2');
  });

  test('compareTo returns equal if IDs match', () {
    final post1 = ChatPost(
        id: 1,
        text: 'text1',
        author: 'author1',
        createdAt: DateTime(2022, 1, 1, 12));
    final post2 = ChatPost(
        id: 1,
        text: 'text2',
        author: 'author2',
        createdAt: DateTime(2022, 1, 2, 12));
    expect(post1.compareTo(post2), 0);
    expect(post2.compareTo(post1), 0);
  });

  test('compareTo returns date compareTo if IDs do not match', () {
    final post1 = ChatPost(
        id: 1,
        text: 'text',
        author: 'author',
        createdAt: DateTime(2022, 1, 1, 12));
    final post2 = ChatPost(
        id: 2,
        text: 'text',
        author: 'author',
        createdAt: DateTime(2022, 1, 2, 12));
    expect(post1.compareTo(post2), greaterThan(0));
    expect(post2.compareTo(post1), lessThan(0));
  });

  test(
      'compareTo returns ID comparison (arbitrary order, but not equal) if dates match',
      () {
    final post1 = ChatPost(
        id: 1,
        text: 'text',
        author: 'author',
        createdAt: DateTime(2022, 1, 1, 12));
    final post2 = ChatPost(
        id: 2,
        text: 'text',
        author: 'author',
        createdAt: DateTime(2022, 1, 1, 12));
    expect(post1.compareTo(post2), isNot(0));
    expect(post2.compareTo(post1), isNot(0));
  });
}
