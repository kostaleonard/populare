//Contains the ChatPost class.

class ChatPost {
  final String text;
  final String author;
  final DateTime createdAt;

  //TODO if you don't specify createdAt, set to DateTime.now()
  ChatPost({required this.text, required this.author, required this.createdAt});
}
