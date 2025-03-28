import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MessageController extends GetxController {
  final messages = <Message>[].obs;
  final unreadCount = 0.obs;

  @override
  void onInit() {
    loadMessages();
    super.onInit();
  }

  void loadMessages() async {
    // 模拟网络请求
    await Future.delayed(Duration(seconds: 1));
    messages.assignAll([
      Message(
          avatar: 'images/head.png',
          name: '张三',
          preview: '今晚一起吃饭吗？',
          time: DateTime.now().subtract(Duration(minutes: 5)),
          unread: 3
      ),
      // 更多模拟数据...
    ]);
  }

  String formatTime(DateTime time) {
    final now = DateTime.now();
    if (now.difference(time).inDays > 1) {
      return DateFormat('MM/dd').format(time);
    }
    return DateFormat('HH:mm').format(time);
  }
}

class Message {
  final String avatar;
  final String name;
  final String preview;
  final DateTime time;
  final int unread;

  Message({required this.avatar, required this.name,
    required this.preview, required this.time, required this.unread});
}