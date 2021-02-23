import 'package:meta/meta.dart';

class Room {
  Room({@required this.id, this.name});
  final String id;
  final String name;

  factory Room.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }

    final String id = data['id'];
    final String name = data['name'];

    return Room(
      id: id,
      name: name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
