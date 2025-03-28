import 'package:best_fish/modules/post/post_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class CustomTabBar extends StatefulWidget {
  final dynamic controller;

  const CustomTabBar({super.key, this.controller});
  @override
  CustomTabBarState createState() => CustomTabBarState(controller: controller);

}
class CustomTabBarState extends State<CustomTabBar> {
  final TabController controller;
  // 状态变量或控制器定义在此处
  final PostController postController = Get.find();

  CustomTabBarState({required this.controller});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: controller,
        isScrollable: true,
        labelColor: Colors.blue,
        unselectedLabelColor: Colors.grey,
        tabs: const [
          Tab(text: '推荐帖子'),
          Tab(text: '热门话题'),
          // 可扩展更多标签...
        ],
        // 修改onTap回调
        onTap: (index) {
          postController.currentTabIndex.value = index;
          controller?.animateTo(index);
        },
        indicatorSize: TabBarIndicatorSize.label,
      ),
    );
  }


}