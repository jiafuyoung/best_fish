import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final TextStyle? textStyle;
  final VoidCallback? onCollapse;
  final bool isCollapsed;

  const SectionHeader({
    super.key,
    required this.title,
    this.backgroundColor = Colors.grey,
    this.textStyle,
    this.onCollapse, required this.isCollapsed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor.withOpacity(0.1),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            title,
            style: textStyle ?? TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600]
            ),
          ),
          Icon(isCollapsed ? Icons.arrow_drop_down : Icons.arrow_drop_up),
        ],
      ),
    );
  }
}