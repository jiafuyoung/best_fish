import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'contact_controller.dart';
import '../../widgets/section_header.dart';

class ContactsView extends StatelessWidget {
  final ContactController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 不写appBar的话没有左上角返回按键
      appBar: AppBar(
        title: const Text('通讯录'),
        elevation: 2,
      ),
      body: Obx(() {
        if (controller.contacts.isEmpty) {
          // 全局空状态
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.contacts, size: 64, color: Colors.grey[400]),
                Text('暂无联系人', style: TextStyle(color: Colors.grey[600]))
              ],
            ),
          );
        }
        return Stack(// 新增 Stack 包裹整个布局
            children: [
          CustomScrollView(
            controller: controller.scrollController, // 关键绑定
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                    (ctx, i) => _buildSection(i),
                    childCount: controller.sectionLetters.length),
              ),
            ],
          ),
          _buildIndexBar(context)
        ]);
      }),
    );
  }

  // 修改 _buildSection 方法
  Widget _buildSection(int index) {
    final letter = controller.sectionLetters[index];
    // final sectionKey = GlobalKey();
    // controller.sectionKeys[letter]=sectionKey;
    final sectionKey = controller.sectionKeys[letter];
    return Obx(() {
      final isCollapsed = controller.collapsedSections.contains(letter);
      final contacts = controller.contacts
          .where((c) => c.pinyin.startsWith(letter))
          .toList();
      if (contacts.isEmpty) {
        return Material(
            child: Column(
          children: [Center(child: Text('暂无联系人'))],
        ));

      }

      return Material(
        key: sectionKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 添加点击交互的标题
            InkWell(
              focusColor: Colors.black,
              onTap: () => controller.toggleSection(letter),
              child: SectionHeader(
                title: letter,
                isCollapsed: isCollapsed,
              ),
            ),
            // 根据折叠状态控制列表显示
            if (!isCollapsed)
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: contacts.length,
                itemBuilder: (ctx, i) => ListTile(
                  leading: CircleAvatar(
                      backgroundImage: AssetImage(contacts[i].avatar)),
                  title: Text(contacts[i].name),
                ),
              ),
          ],
        ),

      );
    });

  }

  // 新增索引栏构建方法
  Widget _buildIndexBar(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        width: 30,
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        child: Center( // 新增 Center 组件
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: controller.sectionLetters.length,
            itemBuilder: (ctx, i) => InkWell(
              onTap: () => _jumpToSection(controller.sectionLetters[i]),
              child: Container(
                height: 28,
                alignment: Alignment.center,
                  child: Text(
                    controller.sectionLetters[i],
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        height: 1.2 // 消除文字默认行高影响
                    ),
                  ),
              ),
            ),
          ),
        ),
      ),
    );
  }

// 新增滚动跳转方法
  void _jumpToSection(String letter) {
    final offset = controller.sectionOffsets[letter];
    if (offset != null && controller.scrollController.hasClients) {
      final double appBarHeight = AppBar().preferredSize.height;
      // 计算相对滚动位置
      final targetPosition = offset - appBarHeight;
      controller.scrollController.animateTo(
        targetPosition,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }else{
      print(offset);
    }
  }
}
