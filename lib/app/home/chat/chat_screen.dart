import 'package:flutter/material.dart';
import 'package:poghouse/app/model/people.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({@required this.people});
  final People people;

  static Future<void> show(BuildContext context, {People people}) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          people: people,
        ),
      ),
    );
  }

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  People get people => widget.people;

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
        child: Text(people.nickname),
      ),
    );
  }
}
