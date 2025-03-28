import 'package:best_fish/models/user_model.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final Rxn<UserModel> currentUser = Rxn<UserModel>();

  void clear() {
    currentUser.value = null;
  }

  void updateUser(UserModel user) {
    currentUser.value = user;
  }
}