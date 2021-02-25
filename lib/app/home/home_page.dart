import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:poghouse/app/home/chat/chat_home.dart';
import 'package:poghouse/app/home/chat/room_action_page.dart';
import 'package:poghouse/app/home/cupertino_home_scaffold.dart';
import 'package:poghouse/app/home/people/people_home.dart';
import 'package:poghouse/app/home/tab_item.dart';
import 'package:poghouse/common_widgets/custom_circle_avatar.dart';
import 'package:poghouse/common_widgets/show_alert_dialog.dart';
import 'package:poghouse/services/auth.dart';
import 'package:poghouse/services/database.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key, @required this.auth}) : super(key: key);
  final Auth auth;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Auth get auth => widget.auth;
  TabItem _currentTab = TabItem.chats;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.chats: GlobalKey<NavigatorState>(),
    TabItem.people: GlobalKey<NavigatorState>(),
  };

  Future<void> _signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(
      context,
      title: 'Logout',
      content: 'Are you sure that you want to logout?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    );

    if (didRequestSignOut == true) {
      _signOut();
    }
  }

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.chats: (_) => ChatHome(auth: auth),
      TabItem.people: (_) => PeopleHome(auth: auth),
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
    return Scaffold(
      appBar: appBar(),
      body: WillPopScope(
        onWillPop: () async =>
            !await navigatorKeys[_currentTab].currentState.maybePop(),
        child: CupertinoHomeScaffold(
          currentTab: _currentTab,
          onSelectTab: _select,
          widgetBuilders: widgetBuilders,
          navigatorKeys: navigatorKeys,
        ),
      ),
    );
  }

  Widget appBar() {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.only(left: 5.0),
        child: CustomCircleAvatar(
          photoUrl: auth.profilePic,
          width: 35,
          backgroundColor: Theme.of(context).primaryColor,
          onTap: () => _confirmSignOut(context),
        ),
      ),
      title: Text((_currentTab == TabItem.chats) ? 'Chats' : "People"),
      actions: <Widget>[
        if (_currentTab == TabItem.chats)
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: IconButton(
              icon: Icon(Icons.message),
              iconSize: 30.0,
              color: Colors.white,
              onPressed: () => RoomActionPage.show(
                context,
                database: Provider.of<Database>(context, listen: false),
              ),
            ),
          ),
      ],
      elevation: 0.0,
    );
  }
}
