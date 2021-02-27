class Message {
  Message({this.id, this.sender, this.sentAt, this.content, this.roomID});

  final String id;
  final String sender;
  final int sentAt;
  final String content;
  final String roomID;

  factory Message.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }

    final String id = data['id'];
    final String sender = data['sender'];
    final int sentAt = data['sentAt'];
    final String content = data['content'];
    final String roomID = data['roomID'];

    return Message(
        id: id,
        sender: sender,
        sentAt: sentAt,
        content: content,
        roomID: roomID);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sender': sender,
      'sentAt': sentAt,
      'content': content,
      'roomID': roomID,
    };
  }
}
