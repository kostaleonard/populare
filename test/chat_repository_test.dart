//Tests chat_repository.dart.

import 'package:flutter_test/flutter_test.dart';
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
}
