import 'package:get/get.dart';

class User {
  String username;
  String email;
  String avatar;

  User({
    this.username = '未登录',
    this.email = '未绑定',
    this.avatar = 'images/head.png',
  });
}

class ProfileController extends GetxController {
  final user = User().obs;

  void editProfile() {
    Get.toNamed('/profile/edit', arguments: user.value);
  }

  void logout() {
    Get.offAllNamed('/login');
    // 执行清理逻辑
    // user.value = User.empty();
  }

  void updateUser(User newUser) {
    user.update((val) {
      val?.username = newUser.username;
      val?.email = newUser.email;
      val?.avatar = newUser.avatar;
    });
  }
}