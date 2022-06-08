//Contains the chat widget.

import 'package:flutter/material.dart';
import 'package:populare/chat_post.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: const Text('Chat with friends, Romans, countrymen')),
        body: Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.all(16.0),
            child: Row(children: [
              Expanded(
                  child: TextField(
                      controller: _textEditingController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Message'),
                      onSubmitted: (String text) {
                        final post = ChatPost(text: text);
                        submitPost(post);
                      })),
              Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: FloatingActionButton(
                      child: const Icon(Icons.send),
                      onPressed: () => {
                            //TODO submit post, but call text field's onSubmitted
                          }))
            ])));
  }

  void submitPost(ChatPost post) {
    //TODO
  }
}
