import 'package:flutter/material.dart';
import 'package:poghouse/app/home/people/people_list_items_builder.dart';
import 'package:poghouse/app/home/people/people_list_tile.dart';
import 'package:poghouse/common_widgets/loading.dart';
import 'package:poghouse/common_widgets/show_exception_alert_dialog.dart';
import 'package:poghouse/services/auth.dart';
import 'package:poghouse/services/database.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class PeopleHome extends StatefulWidget {
  const PeopleHome({Key key, @required this.auth}) : super(key: key);
  final Auth auth;

  @override
  _PeoplePageState createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeopleHome> {
  Auth get auth => widget.auth;

  @override
  Widget build(BuildContext context) {
    // print("Build People");
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
              child: _buildContents(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder(
      stream: CombineLatestStream.list([
        database.peopleStream(),
        database.favoriteStream(auth.currentUser.uid)
      ]),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          showExceptionAlertDialog(
            context,
            title: "Error",
            exception: snapshot.error,
          );
        } else if (snapshot.connectionState == ConnectionState.active) {
          final people = snapshot.data[0];
          final favorite = [for (var p in snapshot.data[1]) p.id as String];
          // print("People: $people");
          // print("People: $favorite");

          return PeopleListItemsBuilder(
            needFiltered: true,
            people: people,
            itemBuilder: (context, people) => PeopleListTile(
              people: people,
              favorite: favorite,
            ),
          );
        }
        return Loading();
      },
    );
  }
}
