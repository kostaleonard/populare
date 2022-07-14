//Contains the ChatPost class.
//ChatPosts are read from the database, not written (diode).

class ChatPost implements Comparable<ChatPost> {
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
      : id = json['id'] as int,
        text = json['text'] as String,
        author = json['author'] as String,
        createdAt = DateTime.parse(json['created_at'] as String);

  String getDisplayDate() {
    return '${createdAt.hour}:${createdAt.minute.toString().padLeft(2, '0')} '
        'on ${createdAt.year}-${createdAt.month}-${createdAt.day}';
  }

  @override
  int compareTo(ChatPost other) {
    if (id == other.id) {
      return 0;
    }
    final dateComparison = createdAt.compareTo(other.createdAt);
    //If the dates are equal, just return some arbitrary order (compare IDs).
    return dateComparison == 0 ? id.compareTo(other.id) : dateComparison;
  }
}
