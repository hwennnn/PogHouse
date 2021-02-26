import 'package:meta/meta.dart';

class Room {
  Room(
      {@required this.id, this.name, this.createdAt, this.owner, this.members});
  final String id;
  final String name;
  final int createdAt;
  final String owner;
  final List<String> members;

  factory Room.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }

    final String id = data['id'];
    final String name = data['name'];
    final int createdAt = data['createdAt'];
    final String owner = data['owner'];
    final List<String> members = data["members"];

    return Room(
        id: id,
        name: name,
        createdAt: createdAt,
        owner: owner,
        members: members);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt,
      'owner': owner,
      'members': members,
    };
  }
}
