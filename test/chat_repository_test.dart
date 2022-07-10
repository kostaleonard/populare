//Tests chat_repository.dart.

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:populare/chat_post_candidate.dart';
import 'package:populare/chat_repository.dart';
import 'chat_repository_test.mocks.dart';

const String localDbProxyUri = 'http://localhost:8000/';
//TODO generate mocks in CI pipeline

@GenerateMocks([http.Client])
void main() {
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
    final client = MockClient();
    final chatRepository =
        ChatRepository(dbProxyUri: localDbProxyUri, client: client);
    when(client.get(Uri.parse(chatRepository.dbProxyHealthUri)))
        .thenAnswer((_) async => http.Response('ok', 200));
    final response = await chatRepository.getDbProxyHealth();
    expect(response.statusCode, 200);
    expect(response.body, 'ok');
  });

  test('createPost returns new post from candidate', () async {
    final client = MockClient();
    final chatRepository =
        ChatRepository(dbProxyUri: localDbProxyUri, client: client);
    when(client.post(Uri.parse(chatRepository.dbProxyGraphqlUri),
            headers: ChatRepository.headers,
            body: '{ createPost(text: "text", author: "author", createdAt: '
                '"2022-07-10T08:07:49.032302") }'))
        .thenAnswer((_) async => http.Response(
            '{"data":{"createPost":"{\\"id\\": 1, \\"text\\": \\"text\\", '
            '\\"author\\": \\"author\\", \\"created_at\\": '
            '\\"2022-07-10T08:07:49.032302\\"}"}}',
            200));
    final postCandidate = ChatPostCandidate(
        text: 'text',
        author: 'author',
        createdAt: DateTime.tryParse('2022-07-10T08:07:49.032302'));
    final post = await chatRepository.createPost(postCandidate);
    expect(post.text, postCandidate.text);
    expect(post.author, postCandidate.author);
    expect(post.createdAt, postCandidate.createdAt);
  });

  test('readPosts returns created posts', () async {
    final client = MockClient();
    final chatRepository =
        ChatRepository(dbProxyUri: localDbProxyUri, client: client);
    when(client.post(Uri.parse(chatRepository.dbProxyGraphqlUri),
            headers: ChatRepository.headers,
            body: argThat(startsWith('{ createPost'), named: 'body')))
        .thenAnswer((_) async => http.Response(
            '{"data":{"createPost":"{\\"id\\": 1, \\"text\\": \\"text\\", '
            '\\"author\\": \\"author\\", \\"created_at\\": '
            '\\"2022-07-10T08:07:49.032302\\"}"}}',
            200));
    when(client.post(Uri.parse(chatRepository.dbProxyGraphqlUri),
            headers: ChatRepository.headers,
            body: argThat(startsWith('{ readPosts'), named: 'body')))
        .thenAnswer((_) async => http.Response(
            '{"data":{"readPosts":["{\\"id\\": 1, \\"text\\": \\"text\\", '
            '\\"author\\": \\"author\\", \\"created_at\\": '
            '\\"2022-07-10T08:07:49.032302\\"}"]}}',
            200));
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

  test('readPosts uses limit', () async {
    final chatRepository = ChatRepository(dbProxyUri: localDbProxyUri);
    const numPosts = 3;
    for (var idx = 0; idx < numPosts; idx++) {
      final postCandidate = ChatPostCandidate(text: 'text$idx');
      await chatRepository.createPost(postCandidate);
    }
    final posts = await chatRepository.readPosts(limit: numPosts - 1);
    expect(posts.length, numPosts - 1);
  }, skip: 'Integration test; requires database proxy');

  test('readPosts uses before', () async {
    final chatRepository = ChatRepository(dbProxyUri: localDbProxyUri);
    final postCandidate1 =
        ChatPostCandidate(text: 'text1', createdAt: DateTime(2022, 1, 1, 12));
    final postCandidate2 =
        ChatPostCandidate(text: 'text2', createdAt: DateTime(2022, 1, 2, 12));
    final postCandidate3 =
        ChatPostCandidate(text: 'text3', createdAt: DateTime(2022, 1, 3, 12));
    await chatRepository.createPost(postCandidate1);
    await chatRepository.createPost(postCandidate2);
    await chatRepository.createPost(postCandidate3);
    final before = DateTime(2022, 1, 2);
    final posts = await chatRepository.readPosts(before: before);
    expect(posts.length, 1);
    expect(posts[0].text, 'text1');
  }, skip: 'Integration test; requires database proxy');

  //TODO test bad connections
}
