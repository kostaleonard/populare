//Contains the ChatPost class.

class ChatPost {
  static const String anonymousAuthor = 'E pluribus unum';
  final String text;
  final String author;
  final DateTime createdAt;

  ChatPost(
      {required this.text, this.author = anonymousAuthor, DateTime? createdAt})
      : createdAt = createdAt ?? DateTime.now();

  String getDisplayDate() {
    return '${createdAt.hour}:${createdAt.minute.toString().padLeft(2, '0')} '
        'on ${createdAt.year}-${createdAt.month}-${createdAt.day}';
  }
}
