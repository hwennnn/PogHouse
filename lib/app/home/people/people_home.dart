import 'package:flutter/material.dart';
import 'package:poghouse/services/auth.dart';

class PeopleHome extends StatefulWidget {
  const PeopleHome({Key key, @required this.auth}) : super(key: key);
  final Auth auth;

  @override
  _PeoplePageState createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeopleHome> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
