import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:poghouse/app/home/chat/chat_screen.dart';
import 'package:poghouse/app/model/rooms.dart';
import 'package:poghouse/common_widgets/custom_circle_avatar.dart';
import 'package:poghouse/common_widgets/loading.dart';
import 'package:poghouse/common_widgets/show_exception_alert_dialog.dart';
import 'package:poghouse/services/database.dart';
import 'package:provider/provider.dart';

class RoomListTile extends StatelessWidget {
  const RoomListTile({Key key, @required this.roomID, this.onTap})
      : super(key: key);
  final String roomID;
  final VoidCallback onTap;

  Widget roomListTile(BuildContext context, Room room) {
    return InkWell(
      child: ListTile(
        leading: CustomCircleAvatar(
          photoUrl: room.photoUrl,
          width: 40,
        ),
        title: Text(room.name),
      ),
      onTap: () => ChatScreen.show(
        context,
        room: room,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder(
      stream: database.roomStream(roomID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          showExceptionAlertDialog(
            context,
            title: "Error",
            exception: snapshot.error,
          );
        } else if (snapshot.connectionState == ConnectionState.active) {
          Map<String, dynamic> result =
              new Map<String, dynamic>.from(snapshot.data.data());
          Room room = Room.fromMap(result);
          return roomListTile(context, room);
        }
        return Loading();
      },
    );
  }
}
