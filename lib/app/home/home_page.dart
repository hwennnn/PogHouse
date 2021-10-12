import 'package:flutter/material.dart';
import 'package:poghouse/app/home/chat/chat_home.dart';
import 'package:poghouse/app/home/room/room_action_page.dart';
import 'package:poghouse/app/home/tab_bar/cupertino_home_scaffold.dart';
import 'package:poghouse/app/home/people/people_home.dart';
import 'package:poghouse/app/home/tab_bar/tab_item.dart';
import 'package:poghouse/common_widgets/custom_circle_avatar.dart';
import 'package:poghouse/common_widgets/show_alert_dialog.dart';
import 'package:poghouse/services/auth.dart';
import 'package:poghouse/services/database.dart';
import 'package:poghouse/services/utils.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.auth}) : super(key: key);
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
    final chats = new ChatHome(auth: auth);
    final people = new PeopleHome(auth: auth);

    return {
      TabItem.chats: (_) => chats,
      TabItem.people: (_) => people,
    };
  }

  void _select(TabItem tabItem) {
    if (tabItem == _currentTab) {
      // pop to first route
      navigatorKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Provider<Utils>(
      create: (_) => Utils(),
      child: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    return Scaffold(
      appBar: appBar() as PreferredSizeWidget?,
      body: WillPopScope(
        onWillPop: () async =>
            !await navigatorKeys[_currentTab]!.currentState!.maybePop(),
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
        padding: const EdgeInsets.only(left: 12.0),
        child: CustomCircleAvatar(
          photoUrl: auth.profilePic,
          width: 40,
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
                auth: Provider.of<AuthBase>(context, listen: false) as Auth?,
              ),
            ),
          ),
      ],
      elevation: 0.0,
    );
  }
}
