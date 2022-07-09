//Contains the ChatRepository class.
//Interfaces with the database proxy to create, read, update, delete posts.

import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:populare/chat_post.dart';

class ChatRepository {
  final String dbProxyUri;
  final String dbProxyHealthUri;
  final String dbProxyGraphqlUri;
  final List<ChatPost> posts;

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
}
