import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:poghouse/app/model/people.dart';
import 'package:poghouse/common_widgets/custom_circle_avatar.dart';
import 'package:poghouse/services/auth.dart';
import 'package:poghouse/services/database.dart';
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

  void addToFavourite(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    if (!isFavourite(context)) {
      database.setFavorite(auth.currentUser.uid, people);
    } else {
      database.removeFavorite(auth.currentUser.uid, people);
    }
  }

  @override
  Widget build(BuildContext context) {
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
        onPressed: () => addToFavourite(context),
      ),
    );
  }
}
