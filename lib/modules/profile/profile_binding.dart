import 'package:best_fish/modules/home/user_service.dart';
import 'package:get/get.dart';
import 'profile_controller.dart';

class ProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileController());

  }


}
