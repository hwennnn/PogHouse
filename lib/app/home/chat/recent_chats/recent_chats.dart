import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poghouse/app/home/chat/recent_chats/chat_list_items_builder.dart';
import 'package:poghouse/app/home/chat/recent_chats/chat_list_tile.dart';
import 'package:poghouse/app/model/rooms.dart';
import 'package:poghouse/common_widgets/loading.dart';
import 'package:poghouse/common_widgets/show_exception_alert_dialog.dart';
import 'package:poghouse/services/database.dart';
import 'package:poghouse/services/utils.dart';
import 'package:provider/provider.dart';

class RecentChats extends StatelessWidget {
  RecentChats({this.roomIDs});
  final List<String> roomIDs;

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    final Utils utils = Provider.of<Utils>(context, listen: false);

    return StreamBuilder(
        stream: database.roomsDetailsStream(roomIDs),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          } else {
            if (snapshot.hasError) {
              showExceptionAlertDialog(
                context,
                title: "Error",
                exception: snapshot.error,
              );
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<Room> rooms = snapshot.data;
              rooms.sort((b, a) => a.lastModified.compareTo(b.lastModified));
              return ChatListItemBuilder(
                rooms: rooms,
                itemBuilder: (context, room) => ChatListTile(
                  room: room,
                  utils: utils,
                ),
              );
            }
          }
        });
  }
}
