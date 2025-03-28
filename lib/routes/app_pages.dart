// 路由配置
import 'package:best_fish/modules/contact/contact_controller.dart';
import 'package:best_fish/modules/contact/contacts_view.dart';
import 'package:best_fish/modules/messages/message_binding.dart';
import 'package:best_fish/modules/messages/message_view.dart';
import 'package:best_fish/modules/post/post_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../controllers/tool_controller.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/home_view.dart';
import '../modules/post/post_binding.dart';
import '../modules/profile/profile_binding.dart';
import '../modules/project/project_binding.dart';
import '../modules/project/project_view.dart';
import '../modules/profile/profile_view.dart';
import '../screens/login_screen.dart';
import '../screens/tool_list_view.dart';

abstract class Routes {
  static const HOME = '/home';
  static const LOGIN = '/login';
  static const POST = '/post';
  static const PROJECT = '/project';
  static const PROFILE = '/profile';
  static const TOOLS = '/tools';
  static const MESSAGES = '/messages';
  static const CONTACTS = '/contacts';
}

class RouteLogger extends GetMiddleware {
  @override
  GetPage? onPageCalled(GetPage? page) {
    assert(page != null, '尝试访问未注册的路由: ${page?.name}');
    return super.onPageCalled(page);
  }
}

class AppPages {
  static final routes = [
    GetPage(name: Routes.LOGIN, page: () => LoginScreen()),
    GetPage(
      name: Routes.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
      middlewares: [
        // AuthMiddleware(), // 添加路由守卫
        RouteLogger()
      ],
    ),
    GetPage(
      name: Routes.POST,
      page: () => PostView(),
      binding: PostBinding(),
      middlewares: [
        // AuthMiddleware(), // 添加路由守卫
        RouteLogger()
      ],
    ),
    // 在 app_pages.dart 添加
    GetPage(
      name: Routes.MESSAGES,
      page: () => MessageView(),
      binding: MessageBinding(),
      middlewares: [
        RouteLogger()
      ],
    ),
    GetPage(
      name: Routes.PROJECT,
      page: () => ProjectView()?? const Placeholder(),
      binding: ProjectBinding(),
      middlewares: [
        // AuthMiddleware(), // 添加路由守卫
        RouteLogger()
      ],
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => ProfileView()?? const Placeholder(),
      binding: ProfileBinding(),
      middlewares: [
        // AuthMiddleware(), // 添加路由守卫
        RouteLogger()
      ],
    ),
    GetPage(
      name: Routes.TOOLS,
      page: () => ToolListView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ToolController>(() => ToolController());
      }),
    ),
    GetPage(
      name: Routes.CONTACTS,
      page: () => ContactsView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ContactController>(() => ContactController());
      }),
    ),
    // 确保以下路由已配置,后续补充，现在先占位保证不报错 todo
    GetPage(name: '/orders',page: () => HomeView()),
    GetPage(name: '/cart', page: () => HomeView(),),
    GetPage(name: '/wallet', page: () => HomeView(),),
    GetPage(name: '/accounting', page: () => HomeView(),),
    GetPage(name: '/scan', page: () => HomeView(),),
  ];
}