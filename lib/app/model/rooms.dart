import 'package:meta/meta.dart';

class Room {
  Room({@required this.id, this.name, this.isPublic});
  final String id;
  final String name;
  final bool isPublic;

  factory Room.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }

    final String id = data['id'];
    final String name = data['name'];
    final bool isPublic = data['isPublic'];

    return Room(
      id: id,
      name: name,
      isPublic: isPublic,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isPublic': isPublic,
    };
  }
}
