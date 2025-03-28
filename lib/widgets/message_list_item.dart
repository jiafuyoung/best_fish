import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modules/messages/message_controller.dart';

class MessageListItem extends StatelessWidget {
  final Message message;

  const MessageListItem({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final formatTime = Get.find<MessageController>().formatTime;

    return ListTile(
      leading: CircleAvatar(backgroundImage: AssetImage(message.avatar)),
      title: Row(
        children: [
          Expanded(child: Text(message.name)),
          Text(formatTime(message.time),
              style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        ],
      ),
      subtitle: Text(message.preview,
          overflow: TextOverflow.ellipsis),
      trailing: message.unread > 0 ? Badge(
        label: Text(message.unread.toString()),
      ) : null,
    );
  }
}