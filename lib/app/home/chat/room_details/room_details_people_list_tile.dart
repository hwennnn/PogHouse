import 'package:flutter/material.dart';
import 'package:poghouse/app/model/people.dart';
import 'package:poghouse/common_widgets/custom_circle_avatar.dart';
import 'package:poghouse/services/auth.dart';
import 'package:provider/provider.dart';

class RoomDetailsPeopleListTile extends StatelessWidget {
  const RoomDetailsPeopleListTile({Key? key, required this.people})
      : super(key: key);
  final People people;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    bool isOwner = people.id == auth.currentUser!.uid;

    return ListTile(
      leading: CustomCircleAvatar(
        photoUrl: people.photoUrl,
        width: 40,
      ),
      title: Text(people.nickname!),
      trailing: isOwner
          ? Text("Owner",
              style: TextStyle(
                color: Color(0xff675C7E),
                fontSize: 12.0,
              ))
          : Text(""),
    );
  }
}
