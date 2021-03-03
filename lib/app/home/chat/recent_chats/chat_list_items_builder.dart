import 'package:flutter/material.dart';
import 'package:poghouse/app/home/chat/empty_content.dart';
import 'package:poghouse/app/model/rooms.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ChatListItemBuilder extends StatelessWidget {
  const ChatListItemBuilder({
    Key key,
    @required this.rooms,
    @required this.itemBuilder,
  }) : super(key: key);
  final List<Room> rooms;
  final ItemWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    if (rooms.isNotEmpty) {
      return _buildList(rooms);
    }

    return EmptyContent();
  }

  Widget _buildList(List<Room> items) {
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
}
