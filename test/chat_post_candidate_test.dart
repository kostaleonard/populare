//Tests chat_post_candidate.dart.

import 'package:flutter_test/flutter_test.dart';
import 'package:populare/chat_post_candidate.dart';

void main() {
  test('Chat post has expected attributes', () {
    final post =
    ChatPostCandidate(text: 'text', author: 'author', createdAt: DateTime(2022));
    expect(post.text, equals('text'));
    expect(post.author, equals('author'));
    expect(post.createdAt, equals(DateTime(2022)));
  });

  test('Chat post created without DateTime uses current time', () {
    //Adding/subtracting to bounds for stability in testing.
    DateTime start = DateTime.now().subtract(const Duration(seconds: 1));
    final post = ChatPostCandidate(text: 'text', author: 'author');
    DateTime end = DateTime.now().add(const Duration(seconds: 1));
    expect(start.isBefore(post.createdAt), true);
    expect(post.createdAt.isBefore(end), true);
  });

  test('Chat post created without author uses anonymous handle', () {
    final post = ChatPostCandidate(text: 'text');
    expect(post.author, equals(ChatPostCandidate.anonymousAuthor));
  });

  test('getDisplayDate returns expected format', () {
    //12:20:15.999 on January 2nd, 2022.
    final date = DateTime(2022, 1, 2, 12, 20, 15, 999);
    final post = ChatPostCandidate(text: 'text', createdAt: date);
    expect(post.getDisplayDate(), '12:20 on 2022-1-2');
  });

  test('getDisplayDate zero-pads minutes', () {
    //3:05:15.999 on January 2nd, 2022.
    final date = DateTime(2022, 1, 2, 3, 05, 15, 999);
    final post = ChatPostCandidate(text: 'text', createdAt: date);
    expect(post.getDisplayDate(), '3:05 on 2022-1-2');
  });

  test('getDisplayDate uses 24 hour time format', () {
    //14:20:15.999 on January 2nd, 2022.
    final date = DateTime(2022, 1, 2, 14, 20, 15, 999);
    final post = ChatPostCandidate(text: 'text', createdAt: date);
    expect(post.getDisplayDate(), '14:20 on 2022-1-2');
  });

  test('Chat post created with whitespace-only text raises error', () {
    expect(() => ChatPostCandidate(text: ' '), throwsArgumentError);
    expect(() => ChatPostCandidate(text: '\t'), throwsArgumentError);
  });
}
