import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poghouse/app/home/chat/recent_chats/room_list_items_builder.dart';
import 'package:poghouse/app/home/chat/recent_chats/room_list_tile.dart';

class RecentChats extends StatelessWidget {
  RecentChats({this.rooms});
  final List<String> rooms;

  @override
  Widget build(BuildContext context) {
    return RoomListItemBuilder(
      rooms: rooms,
      itemBuilder: (context, roomID) => RoomListTile(roomID: roomID),
    );
  }
}
