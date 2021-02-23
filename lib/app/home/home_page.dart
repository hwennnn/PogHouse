import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:poghouse/app/home/room_action_page.dart';
import 'package:poghouse/app/home/room_list_tile.dart';
import 'package:poghouse/app/model/rooms.dart';
import 'package:poghouse/common_widgets/show_alert_dialog.dart';
import 'package:poghouse/common_widgets/show_exception_alert_dialog.dart';
import 'package:poghouse/services/auth.dart';
import 'package:poghouse/services/database.dart';
import 'package:provider/provider.dart';

import 'list_items_builder.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key, @required this.auth}) : super(key: key);
  final Auth auth;

  Future<void> _signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(
      context,
      title: 'Logout',
      content: 'Are you sure that you want to logout?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    );

    if (didRequestSignOut == true) {
      _signOut();
    }
  }

  Future<void> _delete(BuildContext context, Room room) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteRoom(room);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Logout',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: () => _confirmSignOut(context),
          ),
        ],
      ),
      body: _buildContents(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => RoomActionPage.show(
          context,
          database: Provider.of<Database>(context, listen: false),
        ),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Room>>(
      stream: database.roomsStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder<Room>(
          snapshot: snapshot,
          itemBuilder: (context, room) => Dismissible(
            key: Key('room-${room.id}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(context, room),
            child: RoomListTile(
              room: room,
              onTap: () => RoomActionPage.show(
                context,
                database: Provider.of<Database>(context, listen: false),
                room: room,
              ),
            ),
          ),
        );
      },
    );
  }
}
