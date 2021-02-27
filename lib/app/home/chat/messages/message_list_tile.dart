import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:poghouse/app/model/message.dart';

class MessageListTile extends StatelessWidget {
  const MessageListTile({Key key, this.message, this.isMe}) : super(key: key);
  final Message message;
  final bool isMe;

  String readTimestamp(int timestamp) {
    var format = DateFormat('HH:mm');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);

    return format.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: isMe
          ? EdgeInsets.only(
              top: 12.0,
              bottom: 12.0,
              left: 80.0,
            )
          : EdgeInsets.only(
              right: 80,
              top: 12.0,
              bottom: 12.0,
            ),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        color: isMe ? Color(0xffEDEEF7) : Color(0xffF7F7F8),
        borderRadius: isMe
            ? BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
              )
            : BorderRadius.only(
                topRight: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            readTimestamp(message.sentAt),
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 15.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            message.content,
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
