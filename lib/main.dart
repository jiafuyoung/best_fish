import 'package:best_fish/routes/app_pages.dart';
import 'package:best_fish/services/api_client.dart';
import 'package:best_fish/widgets/error_fallback.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:best_fish/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/login/styles/minimal_theme.dart';
import 'controllers/user_controller.dart';
import 'modules/home/home_controller.dart';
import 'modules/profile/profile_controller.dart';
import 'modules/project/project_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化服务
  final apiClient = Get.put(ApiClient());
  final prefs = await SharedPreferences.getInstance();
  // 预加载关键控制器
  Get.put(HomeController());
  Get.put(ProfileController());
  Get.put(ProjectController());
  Get.put(UserController()); // 添加用户控制器
  Get.put(AuthService(apiClient,prefs));
  await apiClient.init();

  runApp(MyApp());
  // 添加全局错误捕获
  FlutterError.onError = (details) {
    print('Caught exception: ${details.exception}');
  };
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    (context, widget) {
      ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
        return ErrorFallbackWidget(errorDetails);
      };
      return widget!;
    };
    return GetMaterialApp(
      title: 'Best fish',
      theme: ThemeData(
        primarySwatch: Colors.blue,
          extensions: [LoginTheme.minimalTheme],
        //后续再设置主题
        // textTheme: TextTheme(bodyMedium: AppStyles.bodyText),
        cardColor: Colors.white, // 建议浅色背景，抽屉卡片颜色有对比度
        // 或 darkTheme: ThemeData(cardColor: Colors.grey[850])
      ),
      //这里要把路由加载进来，否则无法路由跳转
      getPages: AppPages.routes,
      //login 需要加到AppPages.routes
      initialRoute: '/login',
    );
  }
}