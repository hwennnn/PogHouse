import 'package:flutter/material.dart';
import 'package:poghouse/app/model/people.dart';

class PeopleListTile extends StatelessWidget {
  const PeopleListTile({Key key, @required this.people, this.onTap})
      : super(key: key);
  final People people;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: ClipOval(
          child: Image.network(people.photoUrl, width: 40, fit: BoxFit.fill),
        ),
        radius: 20,
      ),
      title: Text(people.nickname),
      trailing: Icon(Icons.star_border),
      onTap: onTap,
    );
  }
}
