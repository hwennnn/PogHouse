import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poghouse/app/home/chat/messages/room_details_people_list_tile.dart';
import 'package:poghouse/app/home/people/people_list_items_builder.dart';
import 'package:poghouse/app/model/message.dart';
import 'package:poghouse/app/model/people.dart';
import 'package:poghouse/app/model/rooms.dart';
import 'package:poghouse/common_widgets/custom_circle_avatar.dart';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:poghouse/common_widgets/loading.dart';
import 'package:poghouse/common_widgets/show_alert_dialog.dart';
import 'package:poghouse/common_widgets/show_exception_alert_dialog.dart';
import 'package:poghouse/services/auth.dart';
import 'package:poghouse/services/database.dart';
import 'package:provider/provider.dart';

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
    await Navigator.of(context, rootNavigator: true).push(
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
        BottomSheetAction(
          title: const Text('Change Image'),
          onPressed: () => _changeImage(context),
        ),
      ],
      cancelAction: CancelAction(
        title: const Text('Cancel'),
      ),
    );
  }

  void _changeChatName(BuildContext context) async {
    final initial = textController.text;
    final auth = Provider.of<AuthBase>(context, listen: false);

    showPlatformDialog(
      context: context,
      builder: (_) => BasicDialogAlert(
        title: Text("Change Chat Name"),
        content: Material(
          child: Container(
            height: 40,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment:
                  CrossAxisAlignment.start, // If you want align text to left
              children: <Widget>[
                TextField(
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  focusNode: focusNode,
                  controller: textController,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.send,
                  autocorrect: false,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                  decoration: InputDecoration.collapsed(
                    hintText: 'Enter a name...',
                  ),
                ),
              ],
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
              final currentName = textController.text;
              if (currentName.length > 20) {
                showAlertDialog(context,
                    title: 'The name is too long',
                    content: 'Please enter a shorter name!',
                    defaultActionText: 'Noted');
                return;
              }

              Navigator.pop(context);
              if (currentName != initial) {
                await database.updateRoomName(room, currentName);
              }
              Navigator.pop(context);

              final currentMs = DateTime.now().millisecondsSinceEpoch;
              final message = Message(
                roomID: room.id,
                id: documentId,
                content:
                    '${auth.currentUser.displayName} has changed the group name',
                sender: auth.currentUser.uid,
                sentAt: currentMs,
                type: 0,
              );
              await database.setMessage(message);
              await database.setRecentMessage(message);
            },
          ),
        ],
      ),
    );
  }

  void _changeImage(BuildContext context) async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    Navigator.pop(context);
    ImagePicker picker = ImagePicker();
    PickedFile pickedFile;
    pickedFile = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      EasyLoading.show(status: 'uploading...');
      final photoUrl = await uploadFile(File(pickedFile.path));
      await database.updateRoomPhoto(room, photoUrl);
      EasyLoading.dismiss();

      final currentMs = DateTime.now().millisecondsSinceEpoch;
      final message = Message(
        roomID: room.id,
        id: documentId,
        content: '${auth.currentUser.displayName} has changed the group photo',
        sender: auth.currentUser.uid,
        sentAt: currentMs,
        type: 0,
      );
      await database.setMessage(message);
      await database.setRecentMessage(message);
    }
  }

  Future<String> uploadFile(File _image) async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('rooms/${_image.path.split('/').last}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;

    String returnURL;
    await storageReference.getDownloadURL().then((fileURL) {
      returnURL = fileURL;
    });
    return returnURL;
  }

  Widget _buildContents(BuildContext context) {
    return Center(
      child: Column(
        children: [
          _buildRoomInfo(),
          _buildPeopleList(room),
        ],
      ),
    );
  }

  Widget _buildRoomInfo() {
    return StreamBuilder(
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
            ],
          );
        }
        return Loading();
      },
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
      body: _buildContents(context),
    );
  }
}
