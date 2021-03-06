import 'package:flutter/material.dart';

enum TabItem { chats, people }

class TabItemData {
  const TabItemData({@required this.title, @required this.icon});

  final String title;
  final IconData icon;

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.chats:
        TabItemData(title: 'Chats', icon: Icons.chat_bubble_outline_rounded),
    TabItem.people:
        TabItemData(title: 'People', icon: Icons.people_alt_rounded),
  };
}
