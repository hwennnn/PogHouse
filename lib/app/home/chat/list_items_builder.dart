import 'package:flutter/material.dart';
import 'package:poghouse/app/home/chat/empty_content.dart';
import 'package:poghouse/app/model/people.dart';
import 'package:poghouse/app/model/rooms.dart';
import 'package:poghouse/services/auth.dart';
import 'package:provider/provider.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemsBuilder<T> extends StatelessWidget {
  const ListItemsBuilder({
    Key key,
    @required this.snapshot,
    @required this.itemBuilder,
  }) : super(key: key);
  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List<T> items = (T == Room)
          ? filterRoom(context, snapshot.data as List<Room>)
          : (T == People)
              ? filterPeople(context, snapshot.data as List<People>)
              : snapshot.data;
      if (items.isNotEmpty) {
        return _buildList(items);
      } else {
        return EmptyContent();
      }
    } else if (snapshot.hasError) {
      return EmptyContent(
        title: 'Something went wrong',
        message: 'Can\'t load items right now',
      );
    }
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildList(List<T> items) {
    return ListView.separated(
      itemCount: items.length + 2,
      separatorBuilder: (context, index) => Divider(height: 0.5),
      itemBuilder: (context, index) {
        if (index == 0 || index == items.length + 1) {
          return Container();
        }
        return itemBuilder(context, items[index - 1]);
      },
    );
  }

  List<Room> filterRoom(BuildContext context, List<Room> rooms) {
    List<Room> result = [];
    final auth = Provider.of<AuthBase>(context, listen: false);
    for (Room room in rooms) {
      if (room.isPublic) {
        result.add(room);
      }
    }

    return result;
  }

  List<People> filterPeople(BuildContext context, List<People> people) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return people.where((i) => i.id != auth.currentUser.uid).toList();
  }
}
