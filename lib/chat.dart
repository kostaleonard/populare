//Contains the chat widget.

import 'package:flutter/material.dart';
import 'package:populare/chat_post.dart';
import 'package:populare/chat_post_candidate.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  late TextEditingController _textEditingController;
  late FocusNode _textFieldFocusNode;
  final _biggerFont = const TextStyle(fontSize: 18);
  List<ChatPost> posts = [];

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: '');
    _textFieldFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _textFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: const Text('Chat with friends, Romans, countrymen')),
        body: Column(
          children: [
            Expanded(
                child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(16.0),
              itemCount: posts.length * 2,
              itemBuilder: (context, i) {
                if (i.isOdd) return const Divider();
                final index = i ~/ 2;
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
                            _textFieldFocusNode.requestFocus();
                          })),
                  Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: FloatingActionButton(
                          child: const Icon(Icons.send),
                          onPressed: () {
                            submitPost(_textEditingController.text);
                            _textEditingController.clear();
                          }))
                ]))
          ],
        ));
  }

  void submitPost(String text) {
    if (text.trim().isEmpty) return;
    final postCandidate = ChatPostCandidate(text: text);
    //TODO write to database
    //TODO read from database (may be automatic with setState)
    //TODO remove this post
    final post = ChatPost(
        id: -1,
        text: postCandidate.text,
        author: postCandidate.author,
        createdAt: postCandidate.createdAt);
    setState(() {
      posts.insert(0, post);
    });
  }
}
