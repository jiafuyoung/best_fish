import 'package:get/get.dart';

class Project {
  final String name;
  final String createdAt;

  Project({required this.name, required this.createdAt});
}

class ProjectController extends GetxController {
  final projects = <Project>[].obs;
  final selectedIndex = (-1).obs;

  int get projectCount => projects.length;

  void selectProject(int index) {
    selectedIndex.value = index;
    Get.toNamed('/project/detail', arguments: projects[index]);
  }

  void createNewProject() {
    final newProject = Project(
      name: '项目 ${projectCount + 1}',
      createdAt: DateTime.now().toString(),
    );
    projects.add(newProject);
  }

  void logout() {
    Get.offAllNamed('/login');
    // 执行清理逻辑
    // user.value = User.empty();
  }
}