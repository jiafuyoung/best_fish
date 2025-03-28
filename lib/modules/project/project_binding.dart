import 'package:get/get.dart';
import 'project_controller.dart';

class ProjectBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProjectController());
    // 预加载相关依赖
    // Get.lazyPut(() => ProjectDetailController());
  }
}