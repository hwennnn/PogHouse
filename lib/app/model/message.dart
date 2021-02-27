class Message {
  Message({this.id, this.sender, this.sentAt, this.content});

  final String id;
  final String sender;
  final int sentAt;
  final String content;

  factory Message.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }

    final String id = data['id'];
    final String sender = data['sender'];
    final int sentAt = data['sentAt'];
    final String content = data['content'];

    return Message(id: id, sender: sender, sentAt: sentAt, content: content);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sender': sender,
      'sentAt': sentAt,
      'content': content,
    };
  }
}
