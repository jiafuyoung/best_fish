// 主框架控制器
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/custom_appbar_controller.dart';
import '../../routes/app_pages.dart';

class HomeController extends GetxController {
  final tabIndex = 0.obs;
  final CustomAppBarController appBarController = Get.put(CustomAppBarController());


  void changeTab(int index) {
    tabIndex.value = index;
    // 同步更新路由状态，不要这一步，否则会立马跳转到一个同样布局的新页面（但是没有下方的 tab_bar）
    _updateRouteState(index);

  }

  void _updateRouteState(int index) {
    switch(index) {
      case 0:
        // Get.offNamedUntil(Routes.PROJECT, (route) => route.isFirst);
        appBarController.switchAppBarType('search');
        break;
      case 1:
        // Get.offNamedUntil(Routes.HOME, (route) => route.isFirst);
        // appBarController.switchAppBarType('filter');
        appBarController.switchAppBarType('custom_ac');
        break;
      case 2:
        appBarController.switchAppBarType('custom');
        // Get.offNamedUntil(Routes.PROFILE, (route) => route.isFirst);
        break;
    }
  }
}