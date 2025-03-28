
import 'package:flutter/material.dart';

class ToolCategory {
  bool expanded=true; // 新增状态字段
  final String name;
  final List<ToolItem> tools;
  final Color categoryColor;

  ToolCategory({
    required this.name,
    required this.tools,
    this.categoryColor = Colors.blue,
  });
}

class ToolItem {
  final String title;
  final IconData icon;
  final Color color;
  final String route; // 路由路径或回调函数

  const ToolItem({
    required this.title,
    required this.icon,
    this.color = Colors.blue,
    required this.route,
  });
}