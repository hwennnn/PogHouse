import 'package:flutter/material.dart';
import 'package:poghouse/app/home/chat/messages/room_details_people_list_tile.dart';
import 'package:poghouse/app/home/people/people_list_items_builder.dart';
import 'package:poghouse/app/model/people.dart';
import 'package:poghouse/app/model/rooms.dart';
import 'package:poghouse/common_widgets/custom_circle_avatar.dart';

class RoomDetailsPage extends StatelessWidget {
  RoomDetailsPage({this.room, this.members});
  final Room room;
  final Map<String, People> members;

  static Future<void> show(
    BuildContext context, {
    Room room,
    Map<String, People> members,
  }) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RoomDetailsPage(
          room: room,
          members: members,
        ),
      ),
    );
  }

  Widget _buildPeopleList() {
    List<People> people = [];
    List<String> uidList = [room.owner, ...room.members];

    for (String uid in uidList) {
      people.add(members[uid]);
    }

    return Expanded(
      child: PeopleListItemsBuilder(
        needFiltered: false,
        people: people,
        itemBuilder: (context, people) => RoomDetailsPeopleListTile(
          people: people,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            CustomCircleAvatar(photoUrl: room.photoUrl, width: 80),
            SizedBox(height: 10),
            Text(
              room.name,
              style: TextStyle(
                color: Color(0xff675C7E),
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 20),
            _buildPeopleList(),
          ],
        ),
      ),
    );
  }
}
