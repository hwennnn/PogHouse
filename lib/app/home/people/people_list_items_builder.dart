import 'package:flutter/material.dart';
import 'package:poghouse/app/home/chat/empty_content.dart';
import 'package:poghouse/app/model/people.dart';
import 'package:poghouse/common_widgets/loading.dart';
import 'package:poghouse/services/auth.dart';
import 'package:provider/provider.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T? item);

class PeopleListItemsBuilder extends StatelessWidget {
  const PeopleListItemsBuilder({
    Key? key,
    required this.people,
    required this.itemBuilder,
    required this.needFiltered,
  }) : super(key: key);
  final List<People?>? people;
  final ItemWidgetBuilder itemBuilder;
  final bool needFiltered;

  @override
  Widget build(BuildContext context) {
    if (people != null && people!.length > 0) {
      final List<People?> items = filterPeople(context, people, needFiltered);
      if (items.isNotEmpty) {
        return _buildList(items);
      }
    } else {
      return EmptyContent();
    }

    return Loading();
  }

  Widget _buildList(List<People?> items) {
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

  List<People?> filterPeople(
      BuildContext context, List<People?>? people, bool needFiltered) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    List<People?> filtered = (needFiltered)
        ? people!.where((i) => i!.id != auth.currentUser!.uid).toList()
        : people!;
    filtered.sort((a, b) => a!.nickname!.compareTo(b!.nickname!));
    return filtered;
  }
}
