// 在 models/ 目录下新建 drawer_card_item.dart
import 'package:flutter/cupertino.dart';

class DrawerCardItem {
  final String title;
  final IconData icon;
  final String route;

  const DrawerCardItem({
    required this.title,
    required this.icon,
    required this.route,
  });
}