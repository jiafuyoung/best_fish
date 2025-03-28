import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/tool_category.dart';

class ToolController extends GetxController {
  final categories = <ToolCategory>[].obs;
  final searchHistory = <String>[].obs;
  final filteredCategories = <ToolCategory>[].obs;

  final searchController = TextEditingController();
  Timer? _debounce; // 新增防抖计时器

  @override
  void onInit() {
    _loadTools();
    searchController.addListener(_onSearchChanged); // 监听输入变化
    super.onInit();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      search(searchController.text); // 延迟500ms执行搜索
    });
  }

  void search(String keyword) {
    final filtered = categories.where((c) {
      return c.tools.any((t) => t.title.contains(keyword));
    }).map((c) => ToolCategory(
      name: c.name,
      tools: c.tools.where((t) => t.title.contains(keyword)).toList(),
      categoryColor: c.categoryColor,
    )).toList();

    filteredCategories.value = filtered;
  }


  void addToHistory(String query) {
    if (!searchHistory.contains(query)) {
      searchHistory.insert(0, query);
      if (searchHistory.length > 5) searchHistory.removeLast();
    }
  }

  // 文件：controllers/tool_controller.dart
  void toggleCategory(int index) {
    final category = categories[index];
    category.expanded = !category.expanded;
    categories.refresh(); // 触发界面更新
  }

  void _loadTools() {
    // 示例数据（根据实际需求修改）
    categories.value = [
      ToolCategory(
        name: '开发工具',
        categoryColor: Colors.blue,
        tools: [
          ToolItem(
            title: 'JSON格式化',
            icon: Icons.code,
            color: Colors.blue,
            route: '/json-formatter',
          ),
          ToolItem(
            title: '加解密',
            icon: Icons.lock,
            color: Colors.purple,
            route: '/encrypt',
          ),
        ],
      ),
      ToolCategory(
        name: '设计工具',
        categoryColor: Colors.green,
        tools: [
          ToolItem(
            title: '颜色选择',
            icon: Icons.color_lens,
            color: Colors.green,
            route: '/color-picker',
          ),
        ],
      ),
    ];
  }
}