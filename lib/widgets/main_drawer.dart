import 'package:best_fish/modules/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/drawer_card_item.dart';
import '../modules/profile/profile_controller.dart';
import '../routes/app_pages.dart';

class MainDrawer extends GetView<ProfileController> {
  const MainDrawer({super.key});

  // 新增卡片数据源（放在类内部）
  final _upperItems = const [
    DrawerCardItem(title: '订单', icon: Icons.list_alt, route: '/orders'),
    DrawerCardItem(title: '购物车', icon: Icons.shopping_cart, route: '/cart'),
    DrawerCardItem(title: '钱包', icon: Icons.account_balance_wallet, route: '/wallet'),
  ];

  final _lowerItems = const [
    DrawerCardItem(title: '记账', icon: Icons.calculate, route: '/accounting'),
    DrawerCardItem(title: '扫码', icon: Icons.qr_code_scanner, route: '/scan'),
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _buildHeader(context),
          // _buildMenuItems(context),
          Expanded(child: _buildMenuItems(context)), // 修改为可滚动区域
          _buildBottomCard(context), // 新增底部卡片
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Obx(() => UserAccountsDrawerHeader(
      accountName: Text(controller.user.value.username),
      accountEmail: Text(controller.user.value.email),
      currentAccountPicture: CircleAvatar(
        backgroundImage: NetworkImage(controller.user.value.avatar),
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
    ));
  }

  Widget _buildMenuItems(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('应用设置'),
            onTap: () => _navigateToSettings(context),
          ),
          ListTile(
            leading: const Icon(Icons.build),
            title: const Text('开发工具'),
            onTap: () {
              Get.back();
              Get.toNamed(Routes.TOOLS);
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('帮助中心'),
            onTap: () => _showHelpDialog(context),
          ),
          ListTile(
            leading: Icon(Icons.contacts),
            title: Text('通讯录'),
            onTap: () => Get.toNamed('/contacts'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('退出登录'),
            onTap: controller.logout,
          ),
        ],
      ),
    );
  }

  // 新增底部卡片组件
  Widget _buildBottomCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).cardColor.withOpacity(0.9),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildButtonRow(context,_upperItems),
              const SizedBox(height: 12),
              _buildButtonRow(context,_lowerItems),
            ],
          ),
        ),
      ),
    );
  }

  // 通用按钮行构建方法
  Widget _buildButtonRow(BuildContext context,List<DrawerCardItem> items) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: items.map((item) => _buildIconButton(context,item)).toList(),
    );
  }

  // 单个按钮组件
  Widget _buildIconButton(BuildContext context,DrawerCardItem item) {
    return Column(
      children: [
        IconButton(
          iconSize: 32,
          icon: Icon(item.icon),
          color: Theme.of(context).primaryColor,
          onPressed: () => _handleCardTap(item.route),
        ),
        Text(item.title,
            style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).hintColor
            ))
      ],
    );
  }

  void _handleCardTap(String route) {
    Get.back(); // 关闭抽屉
    Get.toNamed(route); // 确保路由已配置
  }

  void _navigateToSettings(BuildContext context) {
    Get.back(); // 关闭抽屉
    Get.toNamed('/settings');
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('帮助信息'),
        content: const Text('如需帮助请联系客服\n电话：400-123-4567'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('确定'),
          )
        ],
      ),
    );
  }
}