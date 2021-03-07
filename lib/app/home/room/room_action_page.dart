import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:poghouse/app/home/room/room_people_list_tile.dart';
import 'package:poghouse/app/home/people/people_list_items_builder.dart';
import 'package:poghouse/app/model/message.dart';
import 'package:poghouse/app/model/people.dart';
import 'package:poghouse/app/model/rooms.dart';
import 'package:poghouse/common_widgets/loading.dart';
import 'package:poghouse/common_widgets/show_exception_alert_dialog.dart';
import 'package:poghouse/services/auth.dart';
import 'package:poghouse/services/database.dart';

class RoomActionPage extends StatefulWidget {
  const RoomActionPage(
      {Key key,
      @required this.database,
      @required this.auth,
      this.room,
      this.people})
      : super(key: key);
  final Auth auth;
  final Database database;
  final Room room;
  final List<People> people;

  static Future<void> show(BuildContext context,
      {Database database, Room room, Auth auth}) async {
    List<People> fetchedPeople = await database.retrieveAllPeople();

    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => RoomActionPage(
            database: database, auth: auth, room: room, people: fetchedPeople),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _RoomActionPageState createState() => _RoomActionPageState();
}

class _RoomActionPageState extends State<RoomActionPage> {
  final _formKey = GlobalKey<FormState>();
  Database get database => widget.database;
  Auth get auth => widget.auth;
  List<People> get people => widget.people;
  List<String> _members;
  String _name;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.room != null) {
      _name = widget.room.name;
    }
    _members = [];
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        setState(() {
          _isLoading = true;
        });

        final id = widget.room?.id ?? documentId;
        final currentMs = DateTime.now().millisecondsSinceEpoch;

        final message = Message(
          roomID: id,
          id: documentId,
          content: '${auth.currentUser.displayName} has created the room',
          sender: auth.currentUser.uid,
          sentAt: currentMs,
          type: 0,
        );

        final room = Room(
          id: id,
          name: _name,
          photoUrl:
              'https://yt3.ggpht.com/ytc/AAUvwnhqxIOAZQ5sa7VtGMUpY3lmRO8tMHDidWx0oqkr=s176-c-k-c0x00ffffff-no-rj',
          owner: auth.currentUser.uid,
          members: _members,
          createdAt: currentMs,
          recentMessage: message,
          lastModified: currentMs,
        );

        await database.setRoom(room);
        await database.addRoomToPeople(room);
        await database.setMessage(message);

        setState(() {
          _isLoading = false;
        });

        Navigator.of(context).pop();
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(
          context,
          title: 'Operation failed',
          exception: e,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.room == null ? 'New Room' : 'Edit Room'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Save',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onPressed: _submit,
          ),
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents() {
    return Stack(
      children: <Widget>[
        Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildForm(),
              ),
            ),
          ),
        ),
        // Loading
        Positioned(
          child: _isLoading ? const Loading() : Container(),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Room Name'),
        initialValue: _name,
        validator: (value) => value.isNotEmpty
            ? value.length < 20
                ? null
                : 'The name is too long!'
            : 'Name can\'t be empty',
        onSaved: (value) => _name = value,
      ),
      SizedBox(height: 20),
      Text(
        "Members",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 10),
      _buildPeopleList(),
    ];
  }

  Widget _buildPeopleList() {
    return Expanded(
      child: PeopleListItemsBuilder(
        needFiltered: true,
        people: people,
        itemBuilder: (context, people) => RoomPeopleListTile(
          people: people,
          members: _members,
          onTap: () => _addToMembers(people),
        ),
      ),
    );
  }

  void _addToMembers(People people) {
    setState(() {
      if (!_members.contains(people.id)) {
        _members.add(people.id);
      } else {
        _members.remove(people.id);
      }
    });
  }
}
