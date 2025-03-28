import 'package:get/get.dart';

class PostController extends GetxController {
  final posts = <Map<String, dynamic>>[].obs;
  final currentPage = 1.obs;
  final isLoading = false.obs;
  // 新增多标签状态管理
  final currentTabIndex = 0.obs;
  final tabStates = <int, TabState>{}.obs;

  @override
  void onInit() {
    loadInitialData();
    super.onInit();
    // 初始化两个标签页状态
    tabStates[0] = TabState();
    tabStates[1] = TabState();
    ever(currentTabIndex, (index) {
      if (tabStates[index]!.posts.isEmpty) {
        loadData(index);
      }
    });
  }

  void loadInitialData() async {
    isLoading.value = true;
    // 模拟网络请求
    await Future.delayed(Duration(seconds: 1));
    posts.assignAll(List.generate(10, (index) => _mockPostData(index)));
    isLoading.value = false;
  }

  // 修改后的加载方法（带超时）
  Future<void> loadData(int tabIndex) async {
    final state = tabStates[tabIndex]!;
    if (state.isLoading.value) return;

    state.isLoading.value = true;
    state.isTimeout.value = false;

    try {
      final data = await _fetchData(tabIndex)
          .timeout(Duration(seconds: 10), onTimeout: () {
        state.isTimeout.value = true;
        return [];
      });

      if (data.isNotEmpty) {
        state.posts.addAll(data);
        state.currentPage.value++;
      }
    } finally {
      state.isLoading.value = false;
    }
  }

  Future<List<Map<String, dynamic>>> _fetchData(int tabIndex) async {
    // 不同标签页的模拟数据
    return List.generate(10, (index) => _mockPostData2(index, tabIndex));
  }

  Map<String, dynamic> _mockPostData(int index) {
    return {
      'title': '帖子标题 ${index + 1}',
      'content': '这里是帖子内容，可能会很长需要截断处理。详细内容需要点击查看完整版。',
      'images': List.generate(index % 4, (i) => 'https://picsum.photos/200?random=$i'),
      'likes': (index * 3).toString(),
      'comments': (index * 2).toString(),
      'shares': (index).toString(),
    };
  }

  Map<String, dynamic> _mockPostData2(int index,int tabIndex) {
    return {
      'title': 'Tab$tabIndex帖子标题 ${index + 1}',
      'content': '这里是帖子内容，可能会很长需要截断处理。详细内容需要点击查看完整版。',
      'images': List.generate(index % 4, (i) => 'https://picsum.photos/200?random=$i'),
      'likes': (index * 3).toString(),
      'comments': (index * 2).toString(),
      'shares': (index).toString(),
    };
  }
}

// 新增标签状态类
class TabState {
  final posts = <Map<String, dynamic>>[].obs;
  final currentPage = 1.obs;
  final isLoading = false.obs;
  final isTimeout = false.obs;
}