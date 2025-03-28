import 'package:best_fish/modules/post/post_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/keep_alive_wrapper.dart';
import '../../widgets/custom_tab_bar.dart';
import '../../widgets/post_list_item.dart';

class PostView extends StatefulWidget {
  const PostView({super.key});

  @override
  State<PostView> createState() => _postViewState();
}
class _postViewState extends State<PostView> with TickerProviderStateMixin {
  final PostController postController = Get.put(PostController());
  late TabController _tabController;

  @override
  void initState() {
    // 确保在此处初始化控制器
    _tabController = TabController(
      length: 2, // 与实际 Tab 数量一致
      vsync: this, // 必须使用 TickerProviderStateMixin
    );
    // 首次进入时主动加载标签0数据
    postController.loadData(0);
    // 监听标签切换事件
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) { // [1](@ref)
        postController.loadData(_tabController.index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomTabBar(controller: _tabController), // 新增标签栏
          Expanded(child: TabBarView(
            controller: _tabController,
            children: [
              KeepAliveWrapper(child: _buildPostListView(0)),  // 帖子列表页
              KeepAliveWrapper(child: _buildPostListView(1)),
            ],
          ),
          ), // 原有内容区域
        ],
      ),
    );
  }


  // 替换原有_buildPostListView方法
  Widget _buildPostListView(int tabIndex) {
    return Obx(() {
      final state = postController.tabStates[tabIndex]!;

      return NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
            postController.loadData(tabIndex);
          }
          return true;
        },
        child: RefreshIndicator(
          onRefresh: () async => postController.loadData(tabIndex),
          child: Stack(
            children: [
              // 使用IndexedStack保持页面状态[2](@ref)
              IndexedStack(
                index: postController.currentTabIndex.value,
                children: [
                  _buildContentList(0),
                  _buildContentList(1),
                ],
              ),

              // 超时提示
              if (state.isTimeout.value)
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: _buildTimeoutAlert(),
                ),
            ],
          ),
        ),
      );
    });
  }

  // 新增内容列表构建
  Widget _buildContentList(int tabIndex) {
    final state = postController.tabStates[tabIndex]!;

    return ListView.builder(
      itemCount: state.posts.length + 1,
      itemBuilder: (ctx, index) {
        if (index == state.posts.length) {
          return _buildLoadMoreIndicator(tabIndex);
        }
        return PostListItem(post: state.posts[index]);
      },
    );
  }

// 修改后的加载指示器
  Widget _buildLoadMoreIndicator(int tabIndex) {
    final state = postController.tabStates[tabIndex]!;

    return Visibility(
      visible: state.isLoading.value,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }

// 新增超时提示组件
  Widget _buildTimeoutAlert() {
    return Material(
      color: Colors.amber[100],
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.timer_off, color: Colors.orange),
            SizedBox(width: 8),
            Text('请求超时，请检查网络连接'),
          ],
        ),
      ),
    );
  }
}