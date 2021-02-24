import 'package:flutter/material.dart';
import 'package:poghouse/app/home/chat/empty_content.dart';
import 'package:poghouse/app/model/people.dart';
import 'package:poghouse/common_widgets/loading.dart';
import 'package:poghouse/services/auth.dart';
import 'package:provider/provider.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class PeopleListItemsBuilder extends StatelessWidget {
  const PeopleListItemsBuilder({
    Key key,
    @required this.people,
    @required this.favorite,
    @required this.itemBuilder,
  }) : super(key: key);
  final List<People> people;
  final List<String> favorite;
  final ItemWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    if (people != null && people.length > 0) {
      final List<People> items = filterPeople(context, people);
      if (items.isNotEmpty) {
        return _buildList(items);
      }
    } else {
      return EmptyContent();
    }

    return Loading();
  }

  Widget _buildList(List<People> items) {
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

  List<People> filterPeople(BuildContext context, List<People> people) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return people.where((i) => i.id != auth.currentUser.uid).toList();
  }
}
