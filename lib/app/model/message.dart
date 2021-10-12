class Message {
  Message({
    this.id,
    this.sender,
    this.sentAt,
    this.content,
    this.roomID,
    this.type,
  });

  final String? id;
  final String? sender;
  final int? sentAt;
  final String? content;
  final String? roomID;
  final int? type;

  factory Message.fromMap(Map<String, dynamic> data) {
    final String? id = data['id'];
    final String? sender = data['sender'];
    final int? sentAt = data['sentAt'];
    final String? content = data['content'];
    final String? roomID = data['roomID'];
    final int? type = data['type'];

    return Message(
      id: id,
      sender: sender,
      sentAt: sentAt,
      content: content,
      roomID: roomID,
      type: type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sender': sender,
      'sentAt': sentAt,
      'content': content,
      'roomID': roomID,
      'type': type,
    };
  }
}
