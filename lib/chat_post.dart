//Contains the ChatPost class.
//ChatPosts are retrieved from the database.

class ChatPost {
  final int id;
  final String text;
  final String author;
  final DateTime createdAt;

  ChatPost(
      {required this.id,
      required this.text,
      required this.author,
      required this.createdAt});

  String getDisplayDate() {
    return '${createdAt.hour}:${createdAt.minute.toString().padLeft(2, '0')} '
        'on ${createdAt.year}-${createdAt.month}-${createdAt.day}';
  }
}
