//Contains the ChatFeed class.

import 'dart:collection';
import 'package:populare/chat_post.dart';

class ChatFeed {
  final SplayTreeSet<ChatPost> _posts;

  ChatFeed() : _posts = SplayTreeSet();

  int length() {
    return _posts.length;
  }

  List<ChatPost> getPosts() {
    return _posts.toList();
  }

  void addPost(ChatPost post) {
    _posts.add(post);
  }

  void addPosts(Iterable<ChatPost> posts) {
    posts.forEach(addPost);
  }
}
