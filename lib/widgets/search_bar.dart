import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final TextEditingController controller;
  final FocusNode focusNode;

  const SearchBar({
    super.key,
    required this.controller,
    required this.focusNode,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
          hintText: '搜索工具...',
          border: InputBorder.none,
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
            icon: Icon(Icons.close, color: Colors.grey[600]),
            onPressed: () {
              controller.clear();
              focusNode.unfocus();
            },
          )
              : null,
        ),
        textInputAction: TextInputAction.search,
      ),
    );
  }
}