import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:poghouse/app/model/message.dart';
import 'package:poghouse/app/model/people.dart';
import 'package:poghouse/common_widgets/bubble.dart';
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
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: Row(
        mainAxisAlignment:
            (isMe) ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          (!isMe)
              ? Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Column(
                    children: <Widget>[
                      CustomCircleAvatar(photoUrl: sender.photoUrl, width: 30)
                    ],
                  ),
                )
              : Container(),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (!isMe)
                  ? Padding(
                      padding: EdgeInsets.only(left: 5, bottom: 5),
                      child: Text(
                        sender.nickname,
                        style: TextStyle(
                          color: Color(0xff675C7E),
                          fontSize: 12.0,
                        ),
                      ),
                    )
                  : Container(),
              BubbleMessage(
                painter: BubblePainter(
                  isIncoming: !isMe,
                ),
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: 250.0,
                    minWidth: 50.0,
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
                  child: Text(
                    message.content,
                    style: TextStyle(
                      color: Color(0xff675C7E),
                      fontSize: 15.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              )
            ],
          ), // (!isMe)],
        ],
      ),
    );
  }
}
