import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

class PostListItem extends StatelessWidget {
  final Map<String, dynamic> post;

  const PostListItem({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 标题
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(post['title'],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),

        // 内容截断
        GestureDetector(
          onTap: () => Get.toNamed('/post/detail'),
          child: RichText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              text: post['content'],
              style: DefaultTextStyle.of(context).style,
              children: const [
                TextSpan(
                  text: '... 原文',
                  style: TextStyle(color: Colors.blue),
                )
              ],
            ),
          ),
        ),

        // 图片滑动区域
        if (post['images'].isNotEmpty)
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: post['images'].length,
              itemBuilder: (ctx, i) => Padding(
                padding: const EdgeInsets.only(right: 8, top: 8),
                child: CachedNetworkImage(
                  imageUrl: post['images'][i],
                  width: 160,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

        // 互动按钮
        Row(
          children: [
            IconButton(icon: Icon(Icons.thumb_up), onPressed: () {}),
            Text(post['likes']),
            IconButton(icon: Icon(Icons.comment), onPressed: () {}),
            Text(post['comments']),
            IconButton(icon: Icon(Icons.share), onPressed: () {}),
            Text(post['shares']),
          ],
        ),

        // 分隔线
        const Divider(height: 1, thickness: 1),
      ],
    );
  }
}