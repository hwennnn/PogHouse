import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:poghouse/app/home/chat/messages/message_screen.dart';
import 'package:poghouse/app/model/people.dart';
import 'package:poghouse/app/model/rooms.dart';
import 'package:poghouse/common_widgets/custom_circle_avatar.dart';
import 'package:poghouse/services/auth.dart';
import 'package:poghouse/services/database.dart';
import 'package:poghouse/services/utils.dart';
import 'package:provider/provider.dart';

class PeopleListTile extends StatelessWidget {
  const PeopleListTile(
      {Key key, @required this.people, @required this.favorite, this.onTap})
      : super(key: key);
  final People people;
  final List<String> favorite;
  final VoidCallback onTap;

  bool isFavourite(BuildContext context) {
    return favorite.contains(people.id);
  }

  void addToFavourite(BuildContext context, Database database, Auth auth) {
    if (!isFavourite(context)) {
      database.setFavorite(auth.currentUser.uid, people);
    } else {
      database.removeFavorite(auth.currentUser.uid, people);
    }
  }

  void _showMessageScreen(
    BuildContext context,
    Database database,
    Auth auth,
    Utils utils,
  ) async {
    EasyLoading.show(status: 'loading...');

    final String roomId = utils.getRoomID(auth, people.id);
    final room = Room(
      id: roomId,
      name: people.nickname,
      photoUrl: people.photoUrl,
      isPrivateChat: true,
      members: utils.retrieveMembers(auth, people),
    );

    final bool isRoomExist = await database.isRoomExist(roomId);
    final map = (isRoomExist)
        ? await _constructMembersMap(room, database)
        : utils.constructMemberMap(auth, people);

    EasyLoading.dismiss();

    MessageScreen.show(
      context,
      room: room,
      database: database,
      utils: utils,
      members: map,
      isRoomExist: isRoomExist,
    );
  }

  Future<Map<String, People>> _constructMembersMap(
      Room room, Database database) async {
    List<People> members = await database.retrieveRoomMembers(room);
    Map<String, People> map = new Map();
    for (People people in members) {
      map[people.id] = people;
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    final utils = Provider.of<Utils>(context, listen: false);

    bool _isFavourite = isFavourite(context);
    return ListTile(
      leading: CustomCircleAvatar(
        photoUrl: people.photoUrl,
        width: 40,
      ),
      title: Text(people.nickname),
      trailing: IconButton(
        icon: Icon(
          _isFavourite ? Icons.favorite : Icons.favorite_border,
          color: _isFavourite ? Colors.red : null,
        ),
        onPressed: () => addToFavourite(
          context,
          database,
          auth,
        ),
      ),
      onTap: () => _showMessageScreen(
        context,
        database,
        auth,
        utils,
      ),
    );
  }
}
