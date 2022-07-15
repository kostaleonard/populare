//Tests local_chat_repository.dart.

import 'package:flutter_test/flutter_test.dart';
import 'package:populare/chat_post_candidate.dart';
import 'package:populare/local_chat_repository.dart';

void main() {
  test('Local chat repository always healthy', () async {
    final chatRepository = LocalChatRepository();
    final response = await chatRepository.getDbProxyHealth();
    expect(response.body, 'ok');
    expect(response.statusCode, 200);
  });

  test('Local chat repository creates post', () async {
    final chatRepository = LocalChatRepository();
    final postCandidate = ChatPostCandidate(
        text: 'text',
        author: 'author',
        createdAt: DateTime.tryParse('2022-07-10T08:07:49.032302'));
    final post = await chatRepository.createPost(postCandidate);
    expect(post.text, postCandidate.text);
    expect(post.author, postCandidate.author);
    expect(post.createdAt, postCandidate.createdAt);
  });

  test('Local chat repository returns created posts', () async {
    final chatRepository = LocalChatRepository();
    final postCandidate = ChatPostCandidate(
        text: 'text',
        author: 'author',
        createdAt: DateTime.tryParse('2022-07-10T08:07:49.032302'));
    final post = await chatRepository.createPost(postCandidate);
    final posts = await chatRepository.readPosts();
    expect(posts.length, 1);
    expect(posts[0].id, post.id);
    expect(posts[0].text, post.text);
    expect(posts[0].author, post.author);
    expect(posts[0].createdAt, post.createdAt);
  });
}
