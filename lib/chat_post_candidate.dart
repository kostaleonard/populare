//Contains the ChatPostCandidate class.
//ChatPostCandidates are written to the database, not read (diode).

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
}
