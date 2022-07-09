//Contains the ChatRepository class.
//Interfaces with the database proxy to create, read, update, delete posts.

import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:populare/chat_post.dart';
import 'package:populare/chat_post_candidate.dart';

//TODO need try-catch around HTTP methods--potentially null results
class ChatRepository {
  final String dbProxyUri;
  final String dbProxyHealthUri;
  final String dbProxyGraphqlUri;
  final List<ChatPost> posts;
  static const Map<String, String> headers = {
    'Content-Type': 'application/graphql'
  };

  ChatRepository({required this.dbProxyUri})
      : posts = [],
        dbProxyHealthUri = ChatRepository._buildHealthUri(dbProxyUri),
        dbProxyGraphqlUri = ChatRepository._buildGraphqlUri(dbProxyUri);

  static String _buildHealthUri(String dbProxyUri) {
    return path.join(dbProxyUri, 'health');
  }

  static String _buildGraphqlUri(String dbProxyUri) {
    return path.join(dbProxyUri, 'graphql');
  }

  Future<http.Response> getDbProxyHealth() {
    return http.get(Uri.parse(dbProxyHealthUri));
  }

  Future<ChatPost> createPost(ChatPostCandidate postCandidate) async {
    final body = '{ createPost('
        'text: "${postCandidate.text}", '
        'author: "${postCandidate.author}", '
        'createdAt: "${postCandidate.createdAt.toIso8601String()}") }';
    final response = await http.post(Uri.parse(dbProxyGraphqlUri),
        headers: ChatRepository.headers, body: body);
    return ChatPost.fromJSON(
        jsonDecode(jsonDecode(response.body)['data']['createPost']));
  }

  Future<List<ChatPost>> readPosts({int? limit, DateTime? before}) async {
    var args = '';
    if (limit != null || before != null) {
      args = '(';
      var limitStr = '';
      if (limit != null) {
        limitStr = 'limit: $limit';
      }
      var beforeStr = '';
      if (before != null) {
        beforeStr = 'before: ${before.toIso8601String()}';
      }
      args += [limitStr, beforeStr].join(', ');
      args += ')';
    }
    final body = '{ readPosts$args }';
    final response = await http.post(Uri.parse(dbProxyGraphqlUri),
        headers: ChatRepository.headers, body: body);
    final List<dynamic> postJSONs =
        jsonDecode(response.body)['data']['readPosts'];
    return postJSONs
        .map((postStr) => ChatPost.fromJSON(jsonDecode(postStr)))
        .toList();
  }
}
