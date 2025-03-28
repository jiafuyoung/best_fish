// 依赖注入配置
import 'package:best_fish/modules/home/user_service.dart';
import 'package:best_fish/modules/messages/message_controller.dart';
import 'package:get/get.dart';
import '../profile/profile_controller.dart';
import '../project/project_controller.dart';
import 'home_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    print("依赖注入配置加载 controller");
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => MessageController());
    // 预加载子模块控制器
    Get.lazyPut(() => ProjectController());
    Get.lazyPut(() => ProfileController());

    // 关联服务层
    Get.lazyPut(() => UserService());
  }
}