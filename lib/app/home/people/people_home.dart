import 'package:flutter/material.dart';
import 'package:poghouse/app/home/chat/list_items_builder.dart';
import 'package:poghouse/app/home/people/people_list_tile.dart';
import 'package:poghouse/app/model/people.dart';
import 'package:poghouse/services/auth.dart';
import 'package:poghouse/services/database.dart';
import 'package:provider/provider.dart';

class PeopleHome extends StatefulWidget {
  const PeopleHome({Key key, @required this.auth}) : super(key: key);
  final Auth auth;

  @override
  _PeoplePageState createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeopleHome> {
  @override
  Widget build(BuildContext context) {
    return _buildContents(context);
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<People>>(
      stream: database.peopleStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder<People>(
            snapshot: snapshot,
            itemBuilder: (context, people) => PeopleListTile(people: people));
      },
    );
  }
}
