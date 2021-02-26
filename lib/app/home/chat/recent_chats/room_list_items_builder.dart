import 'package:flutter/material.dart';
import 'package:poghouse/app/home/chat/empty_content.dart';
import 'package:poghouse/common_widgets/loading.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class RoomListItemBuilder extends StatelessWidget {
  const RoomListItemBuilder({
    Key key,
    @required this.rooms,
    @required this.itemBuilder,
  }) : super(key: key);
  final List<String> rooms;
  final ItemWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    if (rooms != null && rooms.length > 0) {
      if (rooms.isNotEmpty) {
        return _buildList(rooms);
      }
    } else {
      return EmptyContent();
    }

    return Loading();
  }

  Widget _buildList(List<String> items) {
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
