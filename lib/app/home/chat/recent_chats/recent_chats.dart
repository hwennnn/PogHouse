import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poghouse/app/home/chat/recent_chats/chat_list_items_builder.dart';
import 'package:poghouse/app/home/chat/recent_chats/chat_list_tile.dart';

class RecentChats extends StatelessWidget {
  RecentChats({this.rooms});
  final List<String> rooms;

  @override
  Widget build(BuildContext context) {
    return ChatListItemBuilder(
      rooms: rooms,
      itemBuilder: (context, roomID) => ChatListTile(roomID: roomID),
    );
  }
}
