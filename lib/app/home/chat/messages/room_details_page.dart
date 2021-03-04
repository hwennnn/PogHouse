import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:poghouse/app/home/chat/messages/room_details_people_list_tile.dart';
import 'package:poghouse/app/home/people/people_list_items_builder.dart';
import 'package:poghouse/app/model/people.dart';
import 'package:poghouse/app/model/rooms.dart';
import 'package:poghouse/common_widgets/custom_circle_avatar.dart';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:poghouse/common_widgets/loading.dart';
import 'package:poghouse/common_widgets/show_exception_alert_dialog.dart';
import 'package:poghouse/services/database.dart';

class RoomDetailsPage extends StatefulWidget {
  RoomDetailsPage({this.room, this.members, this.database});
  final Room room;
  final Map<String, People> members;
  final Database database;

  static Future<void> show(
    BuildContext context, {
    Room room,
    Map<String, People> members,
    Database database,
  }) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RoomDetailsPage(
          room: room,
          members: members,
          database: database,
        ),
      ),
    );
  }

  @override
  _RoomDetailsPageState createState() => _RoomDetailsPageState();
}

class _RoomDetailsPageState extends State<RoomDetailsPage> {
  Room get room => widget.room;
  Database get database => widget.database;
  TextEditingController textController;
  final focusNode = FocusNode();

  @override
  void initState() {
    textController = new TextEditingController(text: room.name);
    super.initState();
  }

  void _displayActionSheet(BuildContext context) {
    showAdaptiveActionSheet(
      context: context,
      actions: <BottomSheetAction>[
        BottomSheetAction(
            title: const Text('Change Chat Name'),
            onPressed: () => _changeChatName(context)),
        BottomSheetAction(title: const Text('Change Image'), onPressed: () {}),
      ],
      cancelAction: CancelAction(
          title: const Text(
              'Cancel')), // onPressed parameter is optional by default will dismiss the ActionSheet
    );
  }

  void _changeChatName(BuildContext context) async {
    final initial = textController.text;

    showPlatformDialog(
      context: context,
      builder: (_) => BasicDialogAlert(
        title: Text("Change Chat Name"),
        content: Material(
          child: Container(
            height: 30,
            child: TextFormField(
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.center,
              focusNode: focusNode,
              controller: textController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration.collapsed(
                hintText: 'Enter a name...',
              ),
              textInputAction: TextInputAction.send,
              autocorrect: false,
            ),
          ),
        ),
        actions: <Widget>[
          BasicDialogAction(
            title: Text("Cancel"),
            onPressed: () {
              Navigator.pop(context);
              textController.text = initial;
            },
          ),
          BasicDialogAction(
            title: Text("OK"),
            onPressed: () async {
              Navigator.pop(context);
              final currentName = textController.text;
              if (currentName != initial) {
                await database.updateRoomName(room, currentName);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPeopleList(Room room) {
    List<People> people = [];
    List<String> uidList = [room.owner, ...room.members];

    for (String uid in uidList) {
      people.add(widget.members[uid]);
    }

    return Expanded(
      child: PeopleListItemsBuilder(
        needFiltered: false,
        people: people,
        itemBuilder: (context, people) => RoomDetailsPeopleListTile(
          people: people,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          FlatButton(
            child: Text(
              'Edit',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onPressed: () => _displayActionSheet(context),
          ),
        ],
      ),
      body: Center(
        child: StreamBuilder(
            stream: database.roomStream(room.id),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                showExceptionAlertDialog(
                  context,
                  title: "Error",
                  exception: snapshot.error,
                );
              } else if (snapshot.connectionState == ConnectionState.active) {
                final Room room = Room.fromMap(snapshot.data.data());
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    CustomCircleAvatar(photoUrl: room.photoUrl, width: 80),
                    SizedBox(height: 10),
                    Text(
                      room.name,
                      style: TextStyle(
                        color: Color(0xff675C7E),
                        fontSize: 18.0,
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildPeopleList(room),
                  ],
                );
              }
              return Loading();
            }),
      ),
    );
  }
}
