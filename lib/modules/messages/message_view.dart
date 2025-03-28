import 'package:best_fish/widgets/message_list_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'message_controller.dart';

class MessageView extends GetView<MessageController> {
  const MessageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.messages.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      return RefreshIndicator(
        onRefresh: () async => controller.loadMessages(),
        child: ListView.separated(
          padding: const EdgeInsets.only(top: 12),
          itemCount: controller.messages.length,
          separatorBuilder: (_, i) => const Divider(height: 1, indent: 72),
          itemBuilder: (context, index) {
            final message = controller.messages[index];
            return MessageListItem(message: message);
          },
        ),
      );
    });
  }

}