import 'package:meta/meta.dart';

class Room {
  Room(
      {@required this.id,
      this.name,
      this.photoUrl,
      this.createdAt,
      this.owner,
      this.members});
  final String id;
  final String name;
  final String photoUrl;
  final int createdAt;
  final String owner;
  final List<String> members;

  factory Room.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }

    final String id = data['id'];
    final String name = data['name'];
    final String photoUrl = data['photoUrl'];
    final int createdAt = data['createdAt'];
    final String owner = data['owner'];
    final List<String> members =
        (data['members'] as List)?.map((item) => item as String)?.toList();

    return Room(
      id: id,
      name: name,
      photoUrl: photoUrl,
      createdAt: createdAt,
      owner: owner,
      members: members,
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
    };
  }
}
