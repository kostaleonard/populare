//Tests chat_repository.dart.

import 'package:flutter_test/flutter_test.dart';
import 'package:populare/chat_post_candidate.dart';
import 'package:populare/chat_repository.dart';

const String localDbProxyUri = 'http://localhost:8000/';
//TODO mock http responses for tests

void main() {
  test('Chat repository initialized with empty post list', () {
    final chatRepository = ChatRepository(dbProxyUri: localDbProxyUri);
    expect(chatRepository.posts, isEmpty);
  });

  test('Chat repository initialized with health endpoint', () {
    const String proxyUri = 'http://localhost:8000/';
    final chatRepository = ChatRepository(dbProxyUri: proxyUri);
    expect(chatRepository.dbProxyHealthUri, 'http://localhost:8000/health');
  });

  test('Chat repository initialized with graphql endpoint', () {
    const String proxyUri = 'http://localhost:8000/';
    final chatRepository = ChatRepository(dbProxyUri: proxyUri);
    expect(chatRepository.dbProxyGraphqlUri, 'http://localhost:8000/graphql');
  });

  test('Chat repository proxy URI trailing slash not necessary', () {
    const String proxyUri = 'http://localhost:8000';
    final chatRepository = ChatRepository(dbProxyUri: proxyUri);
    expect(chatRepository.dbProxyHealthUri, 'http://localhost:8000/health');
    expect(chatRepository.dbProxyGraphqlUri, 'http://localhost:8000/graphql');
  });

  test('getDbProxyHealth retrieves proxy health', () async {
    final chatRepository = ChatRepository(dbProxyUri: localDbProxyUri);
    final response = await chatRepository.getDbProxyHealth();
    expect(response.statusCode, 200);
    expect(response.body, 'ok');
  });

  test('createPost returns new post from candidate', () async {
    final chatRepository = ChatRepository(dbProxyUri: localDbProxyUri);
    final postCandidate = ChatPostCandidate(text: 'text');
    final post = await chatRepository.createPost(postCandidate);
    expect(post.text, postCandidate.text);
    expect(post.author, postCandidate.author);
    expect(post.createdAt, postCandidate.createdAt);
  });

  test('readPosts returns created posts', () async {
    final chatRepository = ChatRepository(dbProxyUri: localDbProxyUri);
    final postCandidate = ChatPostCandidate(text: 'text');
    final post = await chatRepository.createPost(postCandidate);
    final posts = await chatRepository.readPosts();
    expect(posts.length, 1);
    expect(posts[0].id, post.id);
    expect(posts[0].text, post.text);
    expect(posts[0].author, post.author);
    expect(posts[0].createdAt, post.createdAt);
  });

  test('readPosts uses limit', () async {
    final chatRepository = ChatRepository(dbProxyUri: localDbProxyUri);
    const numPosts = 3;
    for (var idx = 0; idx < numPosts; idx++) {
      final postCandidate = ChatPostCandidate(text: 'text$idx');
      await chatRepository.createPost(postCandidate);
    }
    final posts = await chatRepository.readPosts(limit: numPosts - 1);
    expect(posts.length, numPosts - 1);
  });

  test('readPosts uses before', () async {
    final chatRepository = ChatRepository(dbProxyUri: localDbProxyUri);
    final postCandidate1 = ChatPostCandidate(text: 'text1');
    await Future.delayed(const Duration(milliseconds: 10));
    final before = DateTime.now();
    await Future.delayed(const Duration(milliseconds: 10));
    final postCandidate2 = ChatPostCandidate(text: 'text2');
    final postCandidate3 = ChatPostCandidate(text: 'text3');
    await chatRepository.createPost(postCandidate1);
    await chatRepository.createPost(postCandidate2);
    await chatRepository.createPost(postCandidate3);
    final posts = await chatRepository.readPosts(before: before);
    expect(posts.length, 1);
    expect(posts[0].text, 'text1');
  });

  //TODO add mocking

  //TODO test bad connections
}
