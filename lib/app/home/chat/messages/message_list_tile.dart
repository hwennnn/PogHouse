import 'package:flutter/material.dart';
import 'package:poghouse/app/model/message.dart';
import 'package:poghouse/app/model/people.dart';
import 'package:poghouse/common_widgets/bubble.dart';
import 'package:poghouse/common_widgets/custom_circle_avatar.dart';
import 'package:poghouse/services/utils.dart';

class MessageListTile extends StatefulWidget {
  const MessageListTile({
    Key key,
    this.message,
    this.isMe,
    this.isHideNickname,
    this.isHideAvatar,
    this.sender,
    this.utils,
  }) : super(key: key);
  final Message message;
  final bool isMe;
  final bool isHideNickname;
  final bool isHideAvatar;
  final People sender;
  final Utils utils;

  @override
  _MessageListTileState createState() => _MessageListTileState();
}

class _MessageListTileState extends State<MessageListTile> {
  bool _showTimeStamp = false;
  Utils get utils => widget.utils;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: Column(
        children: [
          Visibility(
            visible: _showTimeStamp,
            child: Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                utils.readTimestamp(widget.message.sentAt),
                style: TextStyle(
                  color: Color(0xff675C7E),
                  fontSize: 12.0,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment:
                (widget.isMe) ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Column(
                  children: <Widget>[
                    (!widget.isMe && !widget.isHideAvatar)
                        ? CustomCircleAvatar(
                            photoUrl: widget.sender.photoUrl, width: 30)
                        : SizedBox(width: 30),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (!widget.isMe && !widget.isHideNickname)
                      ? Padding(
                          padding: EdgeInsets.only(left: 5, bottom: 5),
                          child: Text(
                            widget.sender.nickname,
                            style: TextStyle(
                              color: Color(0xff675C7E),
                              fontSize: 12.0,
                            ),
                          ),
                        )
                      : Container(),
                  InkWell(
                    child: BubbleMessage(
                      painter: BubblePainter(
                        isIncoming: !widget.isMe,
                      ),
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: 250.0,
                          minWidth: 50.0,
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 6.0),
                        child: Text(
                          widget.message.content,
                          style: TextStyle(
                            color: Color(0xff675C7E),
                            fontSize: 15.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    onTap: () => setState(() {
                      _showTimeStamp = !_showTimeStamp;
                    }),
                  ),
                ],
              ), // (!isMe)],
            ],
          ),
        ],
      ),
    );
  }
}
