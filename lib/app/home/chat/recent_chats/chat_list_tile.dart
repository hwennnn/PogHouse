import 'package:flutter/material.dart';
import 'package:poghouse/app/home/chat/messages/message_screen.dart';
import 'package:poghouse/app/home/chat/recent_chats/chat_list_loading.dart';
import 'package:poghouse/app/model/people.dart';
import 'package:poghouse/app/model/rooms.dart';
import 'package:poghouse/common_widgets/custom_circle_avatar.dart';
import 'package:poghouse/common_widgets/show_exception_alert_dialog.dart';
import 'package:poghouse/services/auth.dart';
import 'package:poghouse/services/database.dart';
import 'package:poghouse/services/utils.dart';
import 'package:provider/provider.dart';

class ChatListTile extends StatelessWidget {
  const ChatListTile({Key key, @required this.room, this.onTap, this.utils})
      : super(key: key);
  final Room room;
  final VoidCallback onTap;
  final Utils utils;

  Future<Map<String, People>> _constructMembersMap(
      Room room, Database database) async {
    List<People> members = await database.retrieveRoomMembers(room);
    Map<String, People> map = new Map();
    for (People people in members) {
      map[people.id] = people;
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);

    return FutureBuilder<Map<String, People>>(
        future: _constructMembersMap(room, database),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ChatListLoading();
          } else {
            if (snapshot.hasError) {
              showExceptionAlertDialog(
                context,
                title: "Error",
                exception: snapshot.error,
              );
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              Map<String, dynamic> members = snapshot.data;
              String senderName =
                  _formatSenderName(context, members, room, auth);
              final _room = (room.isPrivateChat != null && room.isPrivateChat)
                  ? _getNewRoom(auth, members, room)
                  : room;
              return chatListTile(
                  _room, senderName, members, database, context, auth);
            }
          }
        });
  }

  Room _getNewRoom(Auth auth, Map<String, People> members, Room room) {
    final people = _getPeopleInfo(auth, members, room);
    final newRoom = new Room(
      id: room.id,
      name: people.nickname,
      photoUrl: people.photoUrl,
      members: room.members,
      isPrivateChat: true,
      recentMessage: room.recentMessage,
    );

    return newRoom;
  }

  People _getPeopleInfo(Auth auth, Map<String, People> members, Room room) {
    final currentUid = auth.currentUser.uid;
    final peopleUid =
        room.members[0] == currentUid ? room.members[1] : room.members[0];
    return members[peopleUid];
  }

  String _formatSenderName(
      BuildContext context, Map<String, People> members, Room room, Auth auth) {
    final People sender = members[room.recentMessage.sender];
    return sender.id == auth.currentUser.uid ? "You" : "";
  }

  Widget chatListTile(Room room, String senderName, Map<String, People> members,
      Database database, BuildContext context, Auth auth) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 20.0),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                CustomCircleAvatar(photoUrl: room.photoUrl, width: 40),
                SizedBox(width: 20.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      room.name,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.55,
                      child: Text(
                        (room.recentMessage.type != null &&
                                    room.recentMessage.type == 0 ||
                                senderName == "")
                            ? "${room.recentMessage.content}"
                            : "$senderName: ${room.recentMessage.content}",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13.0,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    utils.readTimestamp(room.recentMessage.sentAt),
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(''),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () => MessageScreen.show(
        context,
        room: room,
        members: members,
        database: database,
        utils: utils,
        isRoomExist: true,
      ),
    );
  }
}
