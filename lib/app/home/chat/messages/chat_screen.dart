import 'package:flutter/material.dart';
import 'package:poghouse/app/home/chat/messages/message_list_items_builder.dart';
import 'package:poghouse/app/model/message.dart';
import 'package:poghouse/app/model/rooms.dart';
import 'package:poghouse/common_widgets/custom_circle_avatar.dart';
import 'package:poghouse/common_widgets/loading.dart';
import 'package:poghouse/common_widgets/show_exception_alert_dialog.dart';
import 'package:poghouse/services/auth.dart';
import 'package:poghouse/services/database.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({
    @required this.room,
    this.database,
  });
  final Room room;
  final Database database;

  static Future<void> show(BuildContext context,
      {Room room, Database database}) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          room: room,
          database: database,
        ),
      ),
    );
  }

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Room get room => widget.room;
  Database get database => widget.database;
  String _content;

  Widget appBar() {
    return AppBar(
      automaticallyImplyLeading: false, // Don't show the leading button
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
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
    );
  }

  Widget _buildContents(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Container(
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
          messages.sort((a, b) => a.sentAt.compareTo(b.sentAt));
          return ListView.builder(
            padding: EdgeInsets.only(top: 15.0),
            itemCount: messages.length,
            itemBuilder: (BuildContext context, int index) {
              final Message message = messages[index];
              final bool isMe = message.sender == uid;
              return MessageListTile(
                message: message,
                isMe: isMe,
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

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                onChanged: (value) => setState(() {
                  _content = value;
                }),
                decoration: InputDecoration.collapsed(
                  hintText: 'Send a message...',
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              iconSize: 25.0,
              color: Theme.of(context).primaryColor,
              onPressed: () => _sendMessage(uid),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage(String uid) {
    final currentMs = DateTime.now().millisecondsSinceEpoch;
    final message = Message(
        id: documentId,
        content: _content,
        sender: uid,
        sentAt: currentMs,
        roomID: room.id);
    database.setMessage(message);
    setState(() {
      _content = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildContents(context);
  }
}
