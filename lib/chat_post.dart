//Contains the ChatPost class.
//ChatPosts are read from the database, not written (diode).

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

  ChatPost.fromJSON(Map<String, dynamic> json)
    : id = json['id'],
      text = json['text'],
      author = json['author'],
      createdAt = DateTime.parse(json['createdAt']);

  String getDisplayDate() {
    return '${createdAt.hour}:${createdAt.minute.toString().padLeft(2, '0')} '
        'on ${createdAt.year}-${createdAt.month}-${createdAt.day}';
  }
}
