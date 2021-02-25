import 'package:flutter/material.dart';
import 'package:poghouse/app/home/chat/favorite_contacts.dart';
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
    print("Build Home");
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
          final favorites = snapshot.data;
          print("Home: $favorites");
          return FavoriteContacts(
            favorites: favorites,
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
