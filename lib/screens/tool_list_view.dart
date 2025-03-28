import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/tool_controller.dart';
import '../models/tool_category.dart';

class ToolListView extends StatelessWidget {
  final ToolController controller = Get.put(ToolController());
  final ScrollController _scrollController = ScrollController();
  final FocusNode _searchFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('实用工具集'),
      //   elevation: 2,
      // ),
      body: GestureDetector(
        onTap: () => _searchFocus.unfocus(), // 点击空白处关闭键盘
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            _buildSliverAppBar(),
            _buildCategoryList(),
          ],
        ),
      )
    );
  }


  Widget _buildSliverAppBar(){
    return SliverAppBar(
      pinned: true,
      floating: true,
      expandedHeight: 120,
      snap: true, // 快速响应滚动[3](@ref)
      stretch: true,
      onStretchTrigger: () async {
        //todo 下拉刷新逻辑
      },
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Column(
          children: [
            const SizedBox(height: kToolbarHeight),
            SearchBar(
              controller: controller.searchController,
              focusNode: _searchFocus,
              onChanged: (v) => controller.search(v),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildCategoryList() {
    return Obx(() => SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          final category = controller.categories[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCategoryHeader(category,index),
              if (category.expanded) _buildToolGrid(category.tools,category),
            ],
          );
        },
        childCount: controller.categories.length,
      ),
    ));
  }

  Widget _buildCategoryHeader(ToolCategory category, index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Row(
        children: [
          IconButton(
            icon: Icon(category.expanded ? Icons.expand_less : Icons.expand_more),
            onPressed: () => controller.toggleCategory(index), // 需在控制器实现方法
          ),
          Container(
            height: 24,
            width: 4,
            color: category.categoryColor,
          ),
          const SizedBox(width: 8),
          Text(
            category.name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: category.categoryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolGrid(List<ToolItem> tools,ToolCategory category) {
    return category.expanded ? GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemCount: tools.length,
      itemBuilder: (context, index) {
        final tool = tools[index];
        return _buildToolItem(tool);
      },
    ): const SizedBox.shrink();// 折叠时隐藏[1,3](@ref)
  }

  Widget _buildToolItem(ToolItem tool) {
    return Material(
      // 悬浮效果增强
      // elevation: 2,
      // shadowColor: tool.color.withOpacity(0.2),
      // surfaceTintColor: tool.color.withOpacity(0.3),

      borderRadius: BorderRadius.circular(12),
      color: tool.color.withOpacity(0.1),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Get.toNamed(tool.route),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(tool.icon, size: 32, color: tool.color),
            const SizedBox(height: 8),
            Text(
              tool.title,
              style: TextStyle(
                fontSize: 12,
                color: tool.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}