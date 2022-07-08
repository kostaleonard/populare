//Contains the ChatPostCandidate class.
//ChatPostCandidates are posted to the database.

class ChatPostCandidate {
  static const String anonymousAuthor = 'E pluribus unum';
  final String text;
  final String author;
  final DateTime createdAt;

  ChatPostCandidate(
      {required this.text, this.author = anonymousAuthor, DateTime? createdAt})
      : createdAt = createdAt ?? DateTime.now() {
    if (text.trim().isEmpty) {
      throw ArgumentError('ChatPost text must not be whitespace-only');
    }
  }

  String getDisplayDate() {
    return '${createdAt.hour}:${createdAt.minute.toString().padLeft(2, '0')} '
        'on ${createdAt.year}-${createdAt.month}-${createdAt.day}';
  }
}
