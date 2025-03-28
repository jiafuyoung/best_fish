import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/custom_appbar_controller.dart';
import 'profile_controller.dart';

class ProfileView extends GetView<ProfileController> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey(); // 新增关键对象
  final CustomAppBarController appBarController = Get.put(CustomAppBarController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.center,
         // 新增自定义顶部栏
        children: [
          // _buildCustomAppBar(context),
          // 用户头像区域
          Obx(() => CircleAvatar(
            radius: 40,
            // backgroundImage: NetworkImage(controller.user.value.avatar),
            backgroundImage: AssetImage(controller.user.value.avatar)
          )),
          const SizedBox(height: 20),

          // 用户信息展示
          Obx(() => Text(
            controller.user.value.username,
            style: Theme.of(context).textTheme.titleLarge,
          )),
          Obx(() => Text(
            controller.user.value.email,
            style: Theme.of(context).textTheme.bodyMedium,
          )),

          const SizedBox(height: 30),

          // 操作按钮区域
          ElevatedButton.icon(
            onPressed: controller.editProfile,
            icon: const Icon(Icons.edit_outlined),
            label: const Text('编辑资料'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ],
      ),
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
              'custom']!,
            ),
          ],
        ),
      ),
    ));
  }
}