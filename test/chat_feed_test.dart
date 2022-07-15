//Tests chat_feed.dart.

import 'package:flutter_test/flutter_test.dart';
import 'package:populare/chat_post.dart';
import 'package:populare/chat_feed.dart';

void main() {
  test('Chat feed starts with no posts', () {
    final feed = ChatFeed();
    expect(feed.getPosts(), isEmpty);
  });

  test('length returns feed length', () {
    final feed = ChatFeed();
    final post1 = ChatPost(
        id: 1,
        text: 'text1',
        author: 'author1',
        createdAt: DateTime(2022, 1, 1, 12));
    final post2 = ChatPost(
        id: 2,
        text: 'text2',
        author: 'author2',
        createdAt: DateTime(2022, 1, 2, 12));
    feed.addPosts([post1, post2]);
    expect(feed.length(), 2);
  });

  test('Chat feed adds posts', () {
    final feed = ChatFeed();
    final post = ChatPost(
        id: 1, text: 'text1', author: 'author1', createdAt: DateTime.now());
    feed.addPost(post);
    final posts = feed.getPosts();
    expect(posts.length, 1);
    expect(posts[0].id, 1);
  });

  test('Chat feed adds multiple posts', () {
    final feed = ChatFeed();
    final post1 = ChatPost(
        id: 1,
        text: 'text1',
        author: 'author1',
        createdAt: DateTime(2022, 1, 1, 12));
    final post2 = ChatPost(
        id: 2,
        text: 'text2',
        author: 'author2',
        createdAt: DateTime(2022, 1, 2, 12));
    feed.addPosts([post1, post2]);
    final posts = feed.getPosts();
    expect(posts.length, 2);
    expect(posts[0].id, 2);
    expect(posts[1].id, 1);
  });

  test('Chat feed does not add duplicate posts based on ID', () {
    final feed = ChatFeed();
    final post1 = ChatPost(
        id: 1,
        text: 'text1',
        author: 'author1',
        createdAt: DateTime(2022, 1, 1, 12));
    final post2 = ChatPost(
        id: 1,
        text: 'text2',
        author: 'author2',
        createdAt: DateTime(2022, 1, 2, 12));
    feed.addPost(post1);
    feed.addPost(post2);
    final posts = feed.getPosts();
    expect(posts.length, 1);
    //The version we keep should be the original.
    expect(posts[0].text, 'text1');
  });

  test('Chat feed returns posts in time-sorted order', () {
    final feed = ChatFeed();
    //Create posts in chronological order with one duplicate.
    final post1 = ChatPost(
        id: 1,
        text: 'text1',
        author: 'author1',
        createdAt: DateTime(2022, 1, 1, 12));
    final post2 = ChatPost(
        id: 1,
        text: 'text2',
        author: 'author2',
        createdAt: DateTime(2022, 1, 2, 12));
    final post3 = ChatPost(
        id: 3,
        text: 'text3',
        author: 'author3',
        createdAt: DateTime(2022, 1, 1, 12));
    final post4 = ChatPost(
        id: 4,
        text: 'text4',
        author: 'author4',
        createdAt: DateTime(2022, 1, 4, 12));
    final post5 = ChatPost(
        id: 5,
        text: 'text5',
        author: 'author5',
        createdAt: DateTime(2022, 1, 4, 12));
    //Add posts in arbitrary order.
    feed.addPost(post3);
    feed.addPost(post1);
    feed.addPost(post2);
    feed.addPost(post5);
    feed.addPost(post4);
    //Posts should be sorted and have no duplicates.
    final posts = feed.getPosts();
    expect(posts.length, 4);
    expect(posts[0].id, 4);
    expect(posts[1].id, 5);
    expect(posts[2].id, 1);
    expect(posts[3].id, 3);
  });

  test('getUnseenPosts removes duplicate posts based on ID', () {
    final feed = ChatFeed();
    final post1 = ChatPost(
        id: 1,
        text: 'text1',
        author: 'author1',
        createdAt: DateTime(2022, 1, 1, 12));
    final post2 = ChatPost(
        id: 1,
        text: 'text2',
        author: 'author2',
        createdAt: DateTime(2022, 1, 2, 12));
    feed.addPost(post1);
    final diff = feed.getUnseenPosts([post2]);
    expect(diff, isEmpty);
  });
}
