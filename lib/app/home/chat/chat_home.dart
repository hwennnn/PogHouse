import 'package:flutter/material.dart';
import 'package:poghouse/services/auth.dart';

class ChatHome extends StatelessWidget {
  const ChatHome({Key key, @required this.auth}) : super(key: key);
  final Auth auth;

  @override
  Widget build(BuildContext context) {
    return _buildContents(context);
  }

  Widget _buildContents(BuildContext context) {
    return Container();
  }
}
