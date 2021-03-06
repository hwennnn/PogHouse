import 'package:flutter/material.dart';
import 'package:poghouse/app/home/chat/messages/message_list_tile.dart';
import 'package:poghouse/app/home/chat/messages/room_details_page.dart';
import 'package:poghouse/app/model/message.dart';
import 'package:poghouse/app/model/people.dart';
import 'package:poghouse/app/model/rooms.dart';
import 'package:poghouse/common_widgets/custom_circle_avatar.dart';
import 'package:poghouse/common_widgets/loading.dart';
import 'package:poghouse/common_widgets/show_exception_alert_dialog.dart';
import 'package:poghouse/services/auth.dart';
import 'package:poghouse/services/database.dart';
import 'package:poghouse/services/utils.dart';
import 'package:provider/provider.dart';

class MessageScreen extends StatefulWidget {
  MessageScreen({
    @required this.room,
    @required this.members,
    this.database,
    this.utils,
    this.isRoomExist,
  });
  final Room room;
  final Map<String, People> members;
  final Database database;
  final Utils utils;
  final bool isRoomExist;

  static Future<void> show(
    BuildContext context, {
    Room room,
    Database database,
    Map<String, People> members,
    Utils utils,
    bool isRoomExist,
  }) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => MessageScreen(
          room: room,
          members: members,
          database: database,
          utils: utils,
          isRoomExist: isRoomExist,
        ),
      ),
    );
  }

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<MessageScreen> {
  bool get isRoomExist => widget.isRoomExist;
  Room get room => widget.room;
  Database get database => widget.database;
  Utils get utils => widget.utils;
  Map<String, People> get members => widget.members;
  final textController = TextEditingController();
  final focusNode = FocusNode();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    textController.dispose();
    super.dispose();
  }

  Widget appBar() {
    return AppBar(
      elevation: 0.0,
      automaticallyImplyLeading: false, // Don't show the leading button
      title: (room.isPrivateChat != null && room.isPrivateChat)
          ? AppBarContent(room: room, members: members, database: database)
          : StreamBuilder(
              stream: database.roomStream(room.id),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  showExceptionAlertDialog(
                    context,
                    title: "Error",
                    exception: snapshot.error,
                  );
                } else if (snapshot.connectionState == ConnectionState.active) {
                  Room room = Room.fromMap(snapshot.data.data());
                  return AppBarContent(
                    room: room,
                    members: members,
                    database: database,
                  );
                }
                return Container();
              },
            ),
    );
  }

  Widget _buildContents(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          color: Theme.of(context).primaryColor,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 30),
                      Expanded(
                        child: _buildMessage(context),
                      ),
                      _buildMessageComposer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessage(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final uid = auth.currentUser.uid;

    return StreamBuilder(
      stream: database.messagesStream(room.id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          showExceptionAlertDialog(
            context,
            title: "Error",
            exception: snapshot.error,
          );
        } else if (snapshot.connectionState == ConnectionState.active) {
          List<Message> messages = snapshot.data;
          final int n = messages.length;
          messages.sort((a, b) => a.sentAt.compareTo(b.sentAt));
          return ListView.builder(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            reverse: true,
            padding: EdgeInsets.only(top: 15.0),
            itemCount: n,
            itemBuilder: (BuildContext context, int index) {
              final Message message = messages[n - index - 1];
              final bool isMe = message.sender == uid;
              final bool isHideNickname = index + 1 < n &&
                  messages[n - index - 2].sender == message.sender &&
                  (messages[n - index - 2].type == null);
              final bool isHideAvatar = index != 0 &&
                  index + 1 < n &&
                  messages[n - index].sender == message.sender &&
                  messages[n - index].type == null;
              return MessageListTile(
                message: message,
                isMe: isMe,
                sender: members[message.sender],
                isHideNickname: isHideNickname,
                isHideAvatar: isHideAvatar,
                utils: utils,
              );
            },
          );
        }
        return Loading();
      },
    );
  }

  Widget _buildMessageComposer() {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final uid = auth.currentUser.uid;

    return Padding(
      padding: EdgeInsets.only(top: 10, left: 30, right: 30, bottom: 30),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xffF7F7F8),
          borderRadius: BorderRadius.circular(30),
        ),
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        height: 60.0,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: TextField(
                  focusNode: focusNode,
                  controller: textController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Send a message...',
                  ),
                  textInputAction: TextInputAction.send,
                  onSubmitted: (value) => _sendMessage(context, uid),
                  autocorrect: false,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              iconSize: 25.0,
              color: Theme.of(context).primaryColor,
              onPressed: () => _sendMessage(context, uid),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage(BuildContext context, String uid) async {
    final content = textController.text;
    if (content != "") {
      final currentMs = DateTime.now().millisecondsSinceEpoch;
      final message = Message(
        id: documentId,
        content: content,
        sender: uid,
        sentAt: currentMs,
        roomID: room.id,
      );

      textController.clear();
      FocusScope.of(context).requestFocus(focusNode);

      if (!isRoomExist) {
        final newRoom = new Room(
          id: room.id,
          members: room.members,
          createdAt: currentMs,
          isPrivateChat: true,
          recentMessage: message,
          lastModified: currentMs,
        );

        await database.setRoom(newRoom);
        await database.addRoomToPeopleR(newRoom, room.members);
      } else {
        await database.setRecentMessage(message);
      }

      await database.setMessage(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildContents(context);
  }
}

class AppBarContent extends StatelessWidget {
  const AppBarContent({
    Key key,
    @required this.room,
    @required this.members,
    @required this.database,
  }) : super(key: key);

  final Room room;
  final Map<String, People> members;
  final Database database;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        InkWell(
          child: Row(
            children: [
              CustomCircleAvatar(
                photoUrl: room.photoUrl,
                width: 40,
                backgroundColor: Theme.of(context).primaryColor,
              ),
              SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(room.name),
                ],
              ),
            ],
          ),
          onTap: () => (room.isPrivateChat != null && room.isPrivateChat)
              ? {}
              : RoomDetailsPage.show(context,
                  room: room, members: members, database: database),
        ),
      ],
    );
  }
}
