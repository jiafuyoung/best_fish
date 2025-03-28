import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'project_controller.dart';

class ProjectView extends GetView<ProjectController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Obx(() => Text('项目 (${controller.projectCount})')),
      // ),
      body: Obx(() => ListView.builder(
        itemCount: controller.projects.length,
        itemBuilder: (ctx, index) => ListTile(
          title: Text(controller.projects[index].name),
          subtitle: Text('创建于: ${controller.projects[index].createdAt}'),
          onTap: () => controller.selectProject(index),
        ),
      )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: controller.createNewProject,
      ),
    );
  }
}