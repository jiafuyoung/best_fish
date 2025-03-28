// 表单字段配置模型（需在auth_form.dart中使用）
import 'package:flutter/material.dart';

class FormFieldConfig {
  final FieldType type;
  final String label;
  final TextEditingController? controller;
  final bool isRequired; // 是否必填
  final String? Function(String?)? customValidator; // 自定义验证方法

  const FormFieldConfig({
    required this.type,
    required this.label,
    this.controller,
    this.isRequired = true,
    this.customValidator,
  });

  // 预定义常用字段配置（简化调用）
  static FormFieldConfig get email => const FormFieldConfig(
    type: FieldType.email,
    label: '邮箱',
  );

  static FormFieldConfig get password => const FormFieldConfig(
    type: FieldType.password,
    label: '密码',
  );
}

// 字段类型枚举（需与Validators配合使用）
enum FieldType { email, password, phone }