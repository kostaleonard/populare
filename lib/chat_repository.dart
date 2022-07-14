//Contains the ChatRepository class.
//Interfaces with the database proxy to create, read, update, delete posts.

import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:populare/chat_post.dart';
import 'package:populare/chat_post_candidate.dart';

class ChatRepository {
  final String dbProxyUri;
  final String dbProxyHealthUri;
  final String dbProxyGraphqlUri;
  final http.Client client;
  static const Map<String, String> headers = {
    'Content-Type': 'application/graphql'
  };
  static const defaultReadLimit = 20;

  ChatRepository({required this.dbProxyUri, http.Client? client})
      : dbProxyHealthUri = ChatRepository._buildHealthUri(dbProxyUri),
        dbProxyGraphqlUri = ChatRepository._buildGraphqlUri(dbProxyUri),
        client = client ?? http.Client();

  static String _buildHealthUri(String dbProxyUri) {
    return path.join(dbProxyUri, 'health');
  }

  static String _buildGraphqlUri(String dbProxyUri) {
    return path.join(dbProxyUri, 'graphql');
  }

  Future<http.Response> getDbProxyHealth() {
    return client.get(Uri.parse(dbProxyHealthUri));
  }

  Future<ChatPost> createPost(ChatPostCandidate postCandidate) async {
    final body = '{ createPost('
        'text: "${postCandidate.text}", '
        'author: "${postCandidate.author}", '
        'createdAt: "${postCandidate.createdAt.toIso8601String()}") }';
    final response = await client.post(Uri.parse(dbProxyGraphqlUri),
        headers: ChatRepository.headers, body: body);
    if (response.statusCode != 200) {
      throw DbProxyCommunicationException('Could not reach database proxy');
    }
    return ChatPost.fromJSON(
        jsonDecode(jsonDecode(response.body)['data']['createPost']));
  }

  Future<List<ChatPost>> readPosts(
      {int limit = ChatRepository.defaultReadLimit, DateTime? before}) async {
    before ??= DateTime.now();
    final limitStr = 'limit: $limit';
    final beforeStr = 'before: "${before.toIso8601String()}"';
    final args = '(${[limitStr, beforeStr].join(', ')})';
    final body = '{ readPosts$args }';
    final response = await client.post(Uri.parse(dbProxyGraphqlUri),
        headers: ChatRepository.headers, body: body);
    if (response.statusCode != 200) {
      throw DbProxyCommunicationException('Could not reach database proxy');
    }
    final List<dynamic> postJSONs =
        jsonDecode(response.body)['data']['readPosts'];
    return postJSONs
        .map((postStr) => ChatPost.fromJSON(jsonDecode(postStr)))
        .toList();
  }
}

class DbProxyCommunicationException implements Exception {
  final String cause;
  DbProxyCommunicationException(String? cause) : cause = cause ?? '';
}
