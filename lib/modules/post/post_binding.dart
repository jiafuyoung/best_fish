import 'package:best_fish/modules/post/post_controller.dart';
import 'package:get/get.dart';

class PostBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PostController());

  }


}
