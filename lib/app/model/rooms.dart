import 'package:meta/meta.dart';
import 'package:poghouse/app/model/message.dart';

class Room {
  Room({
    @required this.id,
    this.name,
    this.photoUrl,
    this.createdAt,
    this.owner,
    this.members,
    this.recentMessage,
    this.lastModified,
    this.isPrivateChat,
  });
  final String id;
  final String name;
  final String photoUrl;
  final int createdAt;
  final String owner;
  final List<String> members;
  final Message recentMessage;
  final int lastModified;
  final bool isPrivateChat;

  factory Room.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }

    final String id = data['id'];
    final String name = data['name'];
    final String photoUrl = data['photoUrl'];
    final int createdAt = data['createdAt'];
    final String owner = data['owner'];
    final int lastModified = data['lastModified'];
    final List<String> members =
        (data['members'] as List)?.map((item) => item as String)?.toList();
    final Message recentMessage = Message.fromMap(data['recentMessage']);
    final bool isPrivateChat = data['isPrivateChat'];

    return Room(
      id: id,
      name: name,
      photoUrl: photoUrl,
      createdAt: createdAt,
      owner: owner,
      members: members,
      recentMessage: recentMessage,
      lastModified: lastModified,
      isPrivateChat: isPrivateChat,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'photoUrl': photoUrl,
      'createdAt': createdAt,
      'owner': owner,
      'members': members,
      'lastModified': lastModified,
      'recentMessage': recentMessage.toMap(),
      'isPrivateChat': isPrivateChat,
    };
  }
}
