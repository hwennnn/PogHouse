import 'package:flutter/material.dart';
import 'package:poghouse/app/home/chat/favorite_contacts.dart';
import 'package:poghouse/app/home/chat/recent_chats/recent_chats.dart';
import 'package:poghouse/app/model/people.dart';
import 'package:poghouse/app/model/rooms.dart';
import 'package:poghouse/common_widgets/loading.dart';
import 'package:poghouse/common_widgets/show_exception_alert_dialog.dart';
import 'package:poghouse/services/auth.dart';
import 'package:poghouse/services/database.dart';
import 'package:provider/provider.dart';

class ChatHome extends StatefulWidget {
  const ChatHome({Key key, @required this.auth}) : super(key: key);
  final Auth auth;

  @override
  _ChatHomeState createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
  Auth get auth => widget.auth;

  @override
  Widget build(BuildContext context) {
    // print("Build Chat");
    return _buildContents(context);
  }

  Widget favoriteContacts() {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder(
      stream: database.favoriteStream(auth.currentUser.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          showExceptionAlertDialog(
            context,
            title: "Error",
            exception: snapshot.error,
          );
        } else if (snapshot.connectionState == ConnectionState.active) {
          List<People> favorites = snapshot.data;
          favorites.sort((a, b) =>
              a.nickname.toLowerCase().compareTo(b.nickname.toLowerCase()));
          // print("Chat: $favorites");
          return FavoriteContacts(
            favorites: favorites,
          );
        }
        return Loading();
      },
    );
  }

  Widget recentChats() {
    final database = Provider.of<Database>(context, listen: false);
    final uid = auth.currentUser.uid;
    return StreamBuilder(
      stream: database.roomsStream(uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          showExceptionAlertDialog(
            context,
            title: "Error",
            exception: snapshot.error,
          );
        } else if (snapshot.connectionState == ConnectionState.active) {
          List<Room> rooms = snapshot.data;
          List<String> roomIDs =
              (rooms.length != 0) ? rooms.map((e) => e.id).toList() : ['dummy'];
          return Expanded(
            child: RecentChats(
              roomIDs: roomIDs,
            ),
          );
        }
        return Loading();
      },
    );
  }

  Widget _buildContents(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: Column(
                children: <Widget>[
                  favoriteContacts(),
                  recentChats(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
