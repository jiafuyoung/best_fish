import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lpinyin/lpinyin.dart';

class ContactController extends GetxController {
  final contacts = <Contact>[].obs;
  final sectionLetters = <String>[].obs;

  // 在ContactController中增加折叠状态
  final collapsedSections = <String>[].obs;
  final ScrollController scrollController = ScrollController(); // 新增滚动控制器[6](@ref)
  final Map<String, double> sectionOffsets = {}; // 存储字母分组偏移量[6](@ref)
  final Map<String, GlobalKey> sectionKeys = {};

  @override
  void onInit() {
    _loadContacts();
    super.onInit();
    initSectionKeys();
  }


  void toggleSection(String letter) {
    if (collapsedSections.contains(letter)) {
      collapsedSections.remove(letter);
    } else {
      collapsedSections.add(letter);
    }
    // WidgetsBinding.instance.scheduleFrame(); // 强制重绘
    // calculateSectionOffsets(); // 重新获取所有组头位置
  }

  // 在 Controller 中预初始化 Key（与数据同步）
  void initSectionKeys() {
    sectionKeys.clear();
    for (var letter in sectionLetters) {
      sectionKeys[letter] = GlobalKey();
    }
  }

// 数据加载完成后调用
  void loadContacts() async {
    // ...加载数据...
    initSectionKeys(); // 关键步骤
  }

// 修改联系人加载逻辑
  void _loadContacts() async {
    final rawData = [
      // A组（3人：2中1英）
      '阿明', '艾琳', 'Alice',
      // B组（3人）
      '白杨', '毕夏', 'Bob',
      // C组（3人）
      '陈曦', '崔雨', 'Chris',
      // D组（3人）
      '丁然', '杜薇', 'David',
      // E组（3人）
      '尔雅', '伊诺', 'Ethan',
      // F组（3人）
      '方舟', '冯雪', 'Fiona',
      // G组（3人）
      '高远', '顾晴', 'Grace',
      // H组（3人）
      '韩露', '何沐', 'Henry',
      // I组（2人：1中1英）
      '伊宁', 'Ivy',
      // J组（3人）
      '季然', '江枫', 'Jack',
      // K组（3人）
      '柯宇', '孔晴', 'Kevin',
      // L组（3人）
      '林森', '梁月', 'Lucas',
      // M组（3人）
      '莫言', '梅雪', 'Mia',
      // N组（3人）
      '倪夏', '宁浩', 'Noah',
      // O组（2人：1中1英）
      '欧阳', 'Oliver',
      // P组（3人）
      '潘阳', '裴星', 'Peter',
      // Q组（3人）
      '齐悦', '曲瑶', 'Quinn',
      // R组（3人）
      '任飞', '荣轩', 'Ruby',
      // S组（3人）
      '沈墨', '苏夏', 'Sophia',
      // T组（3人）
      '唐雨', '田心', 'Theo',
      // U组（3人：2中1英）
      '尤娜', '于航', 'Uma',
      // V组（2人：1中1英）
      '薇薇', 'Victor',
      // W组（4人：3中1英）
      '王五', '娃娃鱼', 'wawa', 'Wendy',
      // X组（3人）
      '夏雪', '谢安', 'Xavier',
      // Y组（3人）
      '杨阳', '余悦', 'Yvonne',
      // Z组（3人）
      '张伟', '周然', 'Zoe'
    ];
    // final rawData = [];
    contacts.assignAll(rawData.map((name) {
      // 添加中文转拼音容错处理
      String pinyin = PinyinHelper.getFirstWordPinyin(name);
      if (pinyin.isEmpty) pinyin = name; // 中文转拼音失败时回退
      return Contact(
        name: name,
        avatar: 'images/head.png',
        pinyin: pinyin.isNotEmpty ? pinyin[0].toUpperCase() : '#',
      );
    }));
    _generateSections();
    calculateSectionOffsets();
    // calculateRealOffsets();
  }

// 修复分组生成逻辑
  void _generateSections() {
    final letters = contacts
        .map((c) => c.pinyin.isNotEmpty ? c.pinyin[0] : '#')
        .toSet()
        .toList();
    letters.sort((a, b) => a.compareTo(b));
    sectionLetters.assignAll(letters);
  }

  // 在数据加载完成后计算偏移量
  void calculateSectionOffsets() {
    double offset = 0;
    for (final letter in sectionLetters) {
      final contacts = _getContactsByLetter(letter);
      sectionOffsets[letter] = offset;
      offset += (contacts.length * 80) + 50; // 列表项高度+组头高度[6](@ref)
    }
  }

  // 在 ContactController 中定义
  void calculateRealOffsets() {
    sectionOffsets.clear(); // 清空旧数据避免干扰

    // 遍历所有分组标题
    for (final letter in sectionLetters) {
      final GlobalKey? key = sectionKeys[letter]; // 获取绑定的Key

      if (key == null || key.currentContext == null) continue;
      if (!key.currentContext!.mounted) continue; // 检查组件是否挂载

      // 获取渲染对象
      final RenderBox box = key.currentContext!.findRenderObject() as RenderBox;

      // 计算全局坐标系中的Y轴偏移
      final globalOffset = box.localToGlobal(Offset.zero).dy;

      // 扣除AppBar高度和安全区域
      final double appBarHeight = AppBar().preferredSize.height;
      final double statusBarHeight = MediaQuery.of(key.currentContext!).padding.top;
      final adjustedOffset = globalOffset - appBarHeight - statusBarHeight;

      sectionOffsets[letter] = adjustedOffset.clamp(0.0, double.infinity);
    }
  }

  // 新增方法：根据字母筛选联系人
  List<Contact> _getContactsByLetter(String letter) {
    return contacts.where((contact) {
      // 处理拼音首字母异常情况
      if (contact.pinyin.isEmpty) return letter == '#';
      // 统一转为大写字母比较
      return contact.pinyin[0].toUpperCase() == letter.toUpperCase();
    }).toList();
  }
}

class Contact {
  final String name;
  final String avatar;
  final String pinyin;

  Contact({required this.name, required this.avatar, required this.pinyin});
}
