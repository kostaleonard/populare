//Contains the LocalChatRepository class.

import 'package:http/http.dart' as http;
import 'package:populare/chat_post.dart';
import 'package:populare/chat_post_candidate.dart';
import 'package:populare/chat_repository.dart';

class LocalChatRepository extends ChatRepository {
  final List<ChatPost> posts = [];

  LocalChatRepository() : super(dbProxyUri: 'http://localhost/dne');

  @override
  Future<http.Response> getDbProxyHealth() {
    return Future.value(http.Response('ok', 200));
  }

  @override
  Future<ChatPost> createPost(ChatPostCandidate postCandidate) async {
    final post = ChatPost(
        id: posts.length + 1,
        text: postCandidate.text,
        author: postCandidate.author,
        createdAt: postCandidate.createdAt);
    posts.insert(0, post);
    return Future.value(post);
  }

  @override
  Future<List<ChatPost>> readPosts(
      {int limit = ChatRepository.defaultReadLimit, DateTime? before}) async {
    return Future.value(posts
        .skipWhile(
            (value) => value.createdAt.compareTo(before ?? DateTime.now()) >= 0)
        .take(limit)
        .toList());
  }
}
