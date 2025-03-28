import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBarController extends GetxController {
  // 当前显示的组件类型
  final currentType = Rx<String>('search');

  // 可配置的组件映射表
  final Map<String, Widget> appbarComponents = {
    'search': _SearchBar(),
    'filter': _FilterBar(),
    'custom': _CustomHeader(),
    'custom_ac': _CustomActionBar(),
  };

  // 动态切换组件类型
  void switchAppBarType(String type) {
    currentType.value = type;
  }

  // 内置搜索栏组件
  static Widget _SearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        decoration: InputDecoration(
          hintText: '全局搜索...',
          prefixIcon: Icon(Icons.search),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // 内置过滤栏组件
  static Widget _FilterBar() {
    return Row(
      children: [
        IconButton(icon: Icon(Icons.tune), onPressed: () {}),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(4, (index) =>
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Chip(label: Text('筛选$index')),
                  )
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 自定义标题组件
  static Widget _CustomHeader() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, color: Colors.amber),
          SizedBox(width: 8),
          Text('自定义标题', style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
          )),
        ],
      ),
    );
  }

  // 自定义操作栏组件
  static Widget _CustomActionBar() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: [
            // 左侧操作区
            _buildLeftActions(),
            // 右侧操作区
            Expanded(child: _buildRightActions()),
          ],
        );
      },
    );
  }

  // 左侧组合组件
  static Widget _buildLeftActions() {
    return Row(
      children: [
        PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(child: Text('操作1')),
            PopupMenuItem(child: Text('操作2')),
          ],
        ),
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () => Get.toNamed('/search'),
        ),

      ],
    );
  }

  // 右侧动态输入区
  static Widget _buildRightActions() {
    return TextField(
      decoration: InputDecoration(
        hintText: '自定义输入...',
        border: InputBorder.none,
        suffixIcon: Icon(Icons.send),
      ),
      onSubmitted: (value) => _handleCustomInput(value),
    );
  }

  static void _handleCustomInput(String value) {
    Get.snackbar('自定义输入', value);
  }
}