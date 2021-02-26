import 'package:flutter/material.dart';
import 'package:poghouse/app/model/people.dart';
import 'package:poghouse/common_widgets/custom_circle_avatar.dart';

class RoomPeopleListTile extends StatelessWidget {
  const RoomPeopleListTile(
      {Key key, @required this.people, @required this.members, this.onTap})
      : super(key: key);
  final People people;
  final List<String> members;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    bool _isMember = members.contains(people.id);
    return ListTile(
      leading: CustomCircleAvatar(
        photoUrl: people.photoUrl,
        width: 40,
      ),
      title: Text(people.nickname),
      trailing: IconButton(
        icon:
            Icon(!_isMember ? Icons.check_box_outline_blank : Icons.check_box),
        onPressed: onTap,
      ),
    );
  }
}
