//Contains the ChatPost class.

import 'package:uuid/uuid.dart';

class ChatPost {
  static const String anonymousAuthor = 'E pluribus unum';
  final String uuid;
  final String text;
  final String author;
  final DateTime createdAt;

  ChatPost(
      {required this.text, this.author = anonymousAuthor, DateTime? createdAt})
      : createdAt = createdAt ?? DateTime.now(),
        uuid = const Uuid().v4();


  String getDisplayDate() {
    return '${createdAt.hour}:${createdAt.minute.toString().padLeft(2, '0')} '
        'on ${createdAt.year}-${createdAt.month}-${createdAt.day}';
  }
}
