import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poghouse/app/model/rooms.dart';
import 'package:poghouse/common_widgets/show_exception_alert_dialog.dart';
import 'package:poghouse/services/database.dart';

class RoomActionPage extends StatefulWidget {
  const RoomActionPage({Key key, @required this.database, this.room})
      : super(key: key);
  final Database database;
  final Room room;

  static Future<void> show(BuildContext context,
      {Database database, Room room}) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => RoomActionPage(database: database, room: room),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _RoomActionPageState createState() => _RoomActionPageState();
}

class _RoomActionPageState extends State<RoomActionPage> {
  final _formKey = GlobalKey<FormState>();

  String _name;
  bool _isPublic = false;

  @override
  void initState() {
    super.initState();
    if (widget.room != null) {
      _name = widget.room.name;
      _isPublic = widget.room.isPublic;
    }
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
        final id = widget.room?.id ?? documentId;
        final room = Room(id: id, name: _name, isPublic: _isPublic);
        await widget.database.setRoom(room);
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
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
        decoration: InputDecoration(labelText: 'Room name'),
        initialValue: _name,
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value,
      ),
      SizedBox(height: 20),
      // switch
      (!Platform.isIOS)
          ? Switch(
              value: _isPublic,
              onChanged: (newValue) {
                setState(() {
                  _isPublic = newValue;
                });
              },
            )
          : CupertinoSwitch(
              value: _isPublic,
              onChanged: (newValue) {
                setState(() {
                  _isPublic = newValue;
                });
              },
            ),
    ];
  }
}
