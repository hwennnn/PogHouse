import 'package:flutter/material.dart';
import 'package:poghouse/app/home/chat/messages/message_screen.dart';
import 'package:poghouse/app/model/people.dart';
import 'package:poghouse/app/model/rooms.dart';
import 'package:poghouse/common_widgets/custom_circle_avatar.dart';
import 'package:poghouse/services/auth.dart';
import 'package:poghouse/services/database.dart';
import 'package:poghouse/services/utils.dart';
import 'package:provider/provider.dart';

class FavoriteContacts extends StatelessWidget {
  FavoriteContacts({this.favorites});
  final List<People> favorites;

  @override
  Widget build(BuildContext context) {
    final utils = Provider.of<Utils>(context, listen: false);
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Favorite Contacts',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.more_horiz,
                  ),
                  iconSize: 30.0,
                  color: Colors.blueGrey,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Container(
            height: 95.0,
            child: ListView.builder(
              padding: EdgeInsets.only(left: 10.0),
              scrollDirection: Axis.horizontal,
              itemCount: favorites.length,
              itemBuilder: (BuildContext context, int index) {
                final people = favorites[index];
                final String roomId = utils.getRoomID(auth, people.id);
                final room = Room(
                  id: roomId,
                  name: people.nickname,
                  photoUrl: people.photoUrl,
                  isPrivateChat: true,
                  members: utils.retrieveMembers(auth, people),
                );
                return Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      CustomCircleAvatar(
                        photoUrl: people.photoUrl,
                        width: 50,
                        onTap: () => {
                          MessageScreen.show(
                            context,
                            room: room,
                            database: database,
                            utils: utils,
                            members: utils.constructMemberMap(auth, people),
                          )
                        },
                      ),
                      SizedBox(height: 6.0),
                      Text(
                        people.nickname,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 13.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
