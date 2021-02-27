import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:poghouse/app/model/message.dart';
import 'package:poghouse/app/model/people.dart';
import 'package:poghouse/common_widgets/custom_circle_avatar.dart';

class MessageListTile extends StatelessWidget {
  const MessageListTile({Key key, this.message, this.isMe, this.sender})
      : super(key: key);
  final Message message;
  final bool isMe;
  final People sender;

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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          (!isMe)
              ? Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Column(
                    children: <Widget>[
                      CustomCircleAvatar(photoUrl: sender.photoUrl, width: 40)
                    ],
                  ),
                )
              : Container(),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (!isMe)
                    ? Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          sender.nickname,
                          style: TextStyle(
                            color: Color(0xff675C7E),
                            fontSize: 14.0,
                          ),
                        ),
                      )
                    : Container(),
                Text(
                  message.content,
                  style: TextStyle(
                    color: Color(0xff675C7E),
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
