import 'package:flutter/material.dart';
import 'package:poghouse/app/model/rooms.dart';

class RoomListTile extends StatelessWidget {
  const RoomListTile({Key key, @required this.room, this.onTap})
      : super(key: key);
  final Room room;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(room.name),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
