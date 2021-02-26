import 'package:flutter/material.dart';
import 'package:poghouse/app/model/rooms.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({@required this.room});
  final Room room;

  static Future<void> show(BuildContext context, {Room room}) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          room: room,
        ),
      ),
    );
  }

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Room get room => widget.room;

  @override
  Widget build(BuildContext context) {
    return _buildContents(context);
  }

  Widget _buildContents(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 2.0,
        title: Text("Messages"),
      ),
      body: Center(
        child: Text(room.name),
      ),
    );
  }
}
