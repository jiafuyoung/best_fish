import 'package:flutter/material.dart';
import '../../services/auth/enums.dart';
import 'models/form_config.dart';

class AuthForm extends StatelessWidget {
  final List<FormFieldConfig> fields;
  final Map<ThirdPartyPlatform, bool> authMethods;

  const AuthForm({
    super.key,
    required this.fields,
    required this.authMethods,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 动态生成表单字段（网页1的字段映射逻辑）
            ...fields.map((config) => _buildField(config)).toList(),

            // 第三方登录组件（保持注释直到实现）
            // if (authMethods.isNotEmpty) ...[
            //   const SizedBox(height: 32),
            //   ThirdPartyAuthPanel(platforms: authMethods),
            // ]
          ],
        ),
      ),
    );
  }

  Widget _buildField(FormFieldConfig config) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: config.controller,
        obscureText: config.type == FieldType.password,
        keyboardType: _getInputType(config.type),
        decoration: InputDecoration(
          labelText: config.label,
          prefixIcon: Icon(_getIcon(config.type)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        validator: (value) => _validateField(config, value),
      ),
    );
  }

  // 字段验证逻辑（网页1的验证规则）
  String? _validateField(FormFieldConfig config, String? value) {
    if (value == null || value.isEmpty) return '${config.label}不能为空';
    if (config.type == FieldType.email && !value.contains('@')) {
      return '请输入有效的邮箱地址';
    }
    return null;
  }

  // 辅助方法
  IconData _getIcon(FieldType type) => switch (type) {
    FieldType.email => Icons.email_outlined,
    FieldType.password => Icons.lock_outline,
    _ => Icons.text_fields,
  };

  TextInputType _getInputType(FieldType type) => switch (type) {
    FieldType.email => TextInputType.emailAddress,
    FieldType.password => TextInputType.visiblePassword,
    _ => TextInputType.text,
  };
}