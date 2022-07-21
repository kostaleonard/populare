//Contains the chat widget.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:populare/chat_feed.dart';
import 'package:populare/chat_post.dart';
import 'package:populare/chat_post_candidate.dart';
import 'package:populare/chat_repository.dart';

class ChatWidget extends StatefulWidget {
  final ChatRepository chatRepository;
  static const String localDbProxyUri = 'http://localhost:8000/';

  ChatWidget({Key? key, ChatRepository? chatRepository})
      : chatRepository =
            chatRepository ?? ChatRepository(dbProxyUri: localDbProxyUri),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  late ChatRepository chatRepository;
  late final Future<http.Response> healthQuery;
  late final Future<List<ChatPost>> initialReadPostsQuery;
  late Future<List<ChatPost>> endOfFeedReadPostsQuery;
  late Future<List<ChatPost>> timerReadPostsQuery;
  Future<ChatPost>? createPostQuery;
  late TextEditingController _textEditingController;
  late FocusNode _textFieldFocusNode;
  late ScrollController _scrollController;
  late Timer readPostsTimer;
  final _biggerFont = const TextStyle(fontSize: 18);
  final feed = ChatFeed();

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: '');
    _textFieldFocusNode = FocusNode();
    _scrollController = ScrollController();
    chatRepository = widget.chatRepository;
    healthQuery = chatRepository.getDbProxyHealth();
    initialReadPostsQuery = chatRepository.readPosts();
    endOfFeedReadPostsQuery = Future.value([]);
    timerReadPostsQuery = Future.value([]);
    readPostsTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      timerReadPostsQuery.whenComplete(() async {
        //Check for recent posts.
        timerReadPostsQuery = chatRepository.readPosts();
        final postsToAdd = await timerReadPostsQuery;
        if (postsToAdd.isNotEmpty &&
            feed.getUnseenPosts(postsToAdd).isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                feed.addPosts(postsToAdd);
              });
            }
          });
        }
      });
    });
  }

  @override
  void dispose() {
    readPostsTimer.cancel();
    _textEditingController.dispose();
    _textFieldFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: const Text('Chat with friends, Romans, countrymen')),
        body: Column(
          children: [
            FutureBuilder<List<ChatPost>>(
                future: initialReadPostsQuery,
                builder: (BuildContext context,
                    AsyncSnapshot<List<ChatPost>> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return Container();
                    case ConnectionState.waiting:
                      return const Center(child: CircularProgressIndicator());
                    default:
                      if (snapshot.hasError) {
                        return Center(
                            child: Text('No connection; try again later',
                                style: _biggerFont));
                      } else {
                        final postsToAdd = snapshot.data ?? [];
                        if (postsToAdd.isNotEmpty &&
                            feed.getUnseenPosts(postsToAdd).isNotEmpty) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) {
                              setState(() {
                                feed.addPosts(postsToAdd);
                              });
                            }
                          });
                        }
                        return Container();
                      }
                  }
                }),
            Expanded(
                child: ListView.builder(
              reverse: true,
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              //Add an extra item to the list to trigger query.
              itemCount: feed.length() * 2 + 1,
              itemBuilder: (context, i) {
                if (i.isOdd) return const Divider();
                final posts = feed.getPosts();
                final index = i ~/ 2;
                if (index >= posts.length) {
                  if (posts.isNotEmpty) {
                    final earliestPost = posts[posts.length - 1];
                    endOfFeedReadPostsQuery.whenComplete(() async {
                      await Future.delayed(const Duration(seconds: 1));
                      endOfFeedReadPostsQuery = chatRepository.readPosts(
                          before: earliestPost.createdAt);
                      final postsToAdd = await endOfFeedReadPostsQuery;
                      if (postsToAdd.isNotEmpty &&
                          feed.getUnseenPosts(postsToAdd).isNotEmpty) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) {
                            setState(() {
                              feed.addPosts(postsToAdd);
                            });
                          }
                        });
                      }
                    });
                  }
                  return Container();
                }
                final post = posts[index];
                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(post.text, style: _biggerFont),
                  subtitle: Text('${post.author}, ${post.getDisplayDate()}'),
                );
              },
            )),
            Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.all(16.0),
                child: Row(children: [
                  Expanded(
                      child: TextField(
                          controller: _textEditingController,
                          focusNode: _textFieldFocusNode,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Message'),
                          onSubmitted: (String text) {
                            submitPost(text);
                            _textEditingController.clear();
                            _scrollController.jumpTo(0);
                            _textFieldFocusNode.requestFocus();
                          })),
                  Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: FloatingActionButton(
                          child: const Icon(Icons.send),
                          onPressed: () {
                            submitPost(_textEditingController.text);
                            _scrollController.jumpTo(0);
                            _textEditingController.clear();
                          }))
                ]))
          ],
        ));
  }

  void submitPost(String text) {
    if (text.trim().isEmpty) return;
    final postCandidate = ChatPostCandidate(text: text);
    createPostQuery = chatRepository.createPost(postCandidate);
    createPostQuery?.then((post) => setState(() {
          feed.addPost(post);
        }));
  }
}
