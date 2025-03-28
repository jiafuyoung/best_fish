// 主框架视图
import 'package:best_fish/common/keep_alive_wrapper.dart';
import 'package:best_fish/modules/messages/message_view.dart';
import 'package:best_fish/modules/post/post_controller.dart';
import 'package:best_fish/modules/post/post_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/custom_appbar_controller.dart';
import '../../widgets/custom_tab_bar.dart';
import '../../widgets/main_drawer.dart';
import '../../widgets/post_list_item.dart';

import '../profile/profile_view.dart';
import '../project/project_view.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey(); // 新增关键对象
  final CustomAppBarController appBarController = Get.put(CustomAppBarController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,// ✅ 关键绑定，否则抽屉就打不开了，抽屉处引用了这个_scaffoldKey
      // 移除原有 appBar 配置
      drawer: const MainDrawer(),
      body: Column(
        children: [
          _buildCustomAppBar(context),  // 新增自定义顶部栏
          Expanded(child: _buildMainContent()), // 原有内容区域
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // 新增自定义顶部栏构建
  Widget _buildCustomAppBar(BuildContext context) {
    return Obx(() => Material(
      elevation: 4,
      child: Container(
        height: kToolbarHeight + 12,
        color: Theme.of(context).appBarTheme.backgroundColor,
        child: Row(
          children: [
            // 保留抽屉菜单按钮
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
            // 动态组件区域
            Expanded(
              child: appBarController.appbarComponents[
              appBarController.currentType.value]!,
            ),
          ],
        ),
      ),
    ));
  }

  // 修改原有内容容器
  Widget _buildMainContent() {
    return Obx(() => IndexedStack(
      index: controller.tabIndex.value,
      children: [
        PostView(),
        MessageView(),
        ProjectView(),
        ProfileView(),
      ],
    ));
  }

  // 底部导航栏构建
  Widget _buildBottomBar() {
    return Obx(() => BottomNavigationBar(
      currentIndex: controller.tabIndex.value,
      onTap: controller.changeTab,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.work_outline),
          label: '资讯',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message),
          label: '消息',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: '首页',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: '我的',
        ),
      ],
    ));
  }





}


