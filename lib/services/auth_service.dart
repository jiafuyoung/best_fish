import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:best_fish/models/user_model.dart';
import '../controllers/user_controller.dart';
import 'api_client.dart';

class AuthService extends GetxService {
  final ApiClient _api;
  final Rxn<UserModel> currentUser = Rxn<UserModel>();
  final SharedPreferences _prefs;

  AuthService(this._api, this._prefs);

  Future<bool> login(String email, String password) async {
    try {
      final response = await _api.post('/login', {
        'email': email,
        'password': password
      });

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response.data['token']);
        currentUser.value = UserModel.fromJson(response.data['user']);
        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    try {
      // 调用API服务端注销（需根据实际API文档调整）
      await _api.post('/auth/logout', {});
    } finally {
      // 本地凭证清除（网页2的技术规范）
      await _prefs.remove('agc_token');
      await _prefs.remove('agc_refresh_token');

      // 清除全局用户状态（网页3的SSO规范）
      Get.find<UserController>().clear();

      // 跳转登录页（网页1的重定向实现）
      Get.offAllNamed('/login');
    }
  }

  // 在AuthService类中添加
  Future<bool> huaweiPhoneLogin(
      String countryCode,
      String phoneNumber,
      String verifyCode
      ) async {
    try {
      final response = await _api.huaweiAuth('phone', {
        'countryCode': countryCode,
        'phoneNumber': phoneNumber,
        'verifyCode': verifyCode
      });

      _handleAuthResponse(response as Response);
      return true;
    } catch (e) {
      print('华为手机登录失败: $e');
      return false;
    }
  }

  // 在AuthService类中添加以下方法
  void _handleAuthResponse(Response response) {
    final data = response.body as Map<String, dynamic>;

    // 空安全处理（网页3规范）
    final token = data['token']?.toString();
    final userData = data['user'] as Map<String, dynamic>?;

    if (token == null || userData == null) {
      throw '无效的登录响应数据格式';
    }

    // 用户数据处理
    final user = UserModel.fromJson(userData);
    Get.find<UserController>().updateUser(user);

    // 凭证存储（网页2安全规范）
    _prefs.setString('token', token);
  }
}