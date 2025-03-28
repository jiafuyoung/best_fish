class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) return '邮箱不能为空';
    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(value)) {
      return '邮箱格式不正确';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return '密码不能为空';
    if (value.length < 8) return '密码至少8位字符';
    if (!value.contains(RegExp(r'[A-Z]'))) return '需包含大写字母';
    return null;
  }
}