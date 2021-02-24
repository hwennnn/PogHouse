import 'package:flutter/material.dart';
import 'package:poghouse/app/home/chat/chat_home.dart';
import 'package:poghouse/app/home/cupertino_home_scaffold.dart';
import 'package:poghouse/app/home/tab_item.dart';
import 'package:poghouse/services/auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key, @required this.auth}) : super(key: key);
  final Auth auth;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.chats;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.chats: GlobalKey<NavigatorState>(),
    TabItem.people: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.chats: (_) => ChatHome(auth: widget.auth),
      TabItem.people: (_) => Container(),
    };
  }

  void _select(TabItem tabItem) {
    if (tabItem == _currentTab) {
      // pop to first route
      navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: CupertinoHomeScaffold(
        currentTab: _currentTab,
        onSelectTab: _select,
        widgetBuilders: widgetBuilders,
        navigatorKeys: navigatorKeys,
      ),
    );
  }
}
