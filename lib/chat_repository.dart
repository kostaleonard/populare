//Contains the ChatRepository class.
//Interfaces with the database proxy to create, read, update, delete posts.

import 'dart:collection';
import 'dart:convert';

import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:populare/chat_post.dart';
import 'package:populare/chat_post_candidate.dart';

class ChatRepository {
  final String dbProxyUri;
  final String dbProxyHealthUri;
  final String dbProxyGraphqlUri;
  final List<ChatPost> posts;
  static const Map<String, String> headers = {'Content-Type': 'application/graphql'};

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

  //TODO create from ChatPostCandidate
  Future<ChatPost> createPost(ChatPostCandidate postCandidate) async {
    //TODO build body from candidate
    String body = '{ createPost(text: "my text", author: "my author", createdAt: "2006-01-02T15:04:05") }';
    final response = await http.post(Uri.parse(dbProxyGraphqlUri), headers: ChatRepository.headers, body: body);
    return ChatPost.fromJSON(jsonDecode(response.body));
  }

  //TODO read into ChatPosts
}
