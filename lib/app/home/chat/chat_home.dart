import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:poghouse/app/home/chat/list_items_builder.dart';
import 'package:poghouse/app/home/chat/room_action_page.dart';
import 'package:poghouse/app/home/chat/room_list_tile.dart';
import 'package:poghouse/app/model/rooms.dart';
import 'package:poghouse/common_widgets/show_exception_alert_dialog.dart';
import 'package:poghouse/services/auth.dart';
import 'package:poghouse/services/database.dart';
import 'package:provider/provider.dart';

class ChatHome extends StatelessWidget {
  const ChatHome({Key key, @required this.auth}) : super(key: key);
  final Auth auth;

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
    return _buildContents(context);
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return Container();
  }
}
