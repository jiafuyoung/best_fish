// 用户服务 (modules/profile/user_service.dart)
import 'package:get/get.dart';
import 'package:best_fish/modules/profile/profile_controller.dart';

class UserService extends GetxService {
  Future<User> fetchUser() async {
    // 实现网络请求逻辑
    return User();
  }
}