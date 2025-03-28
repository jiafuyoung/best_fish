import 'package:flutter/material.dart';

import '../dynamic_background.dart';

class LoginTheme extends ThemeExtension<LoginTheme> {
  final EdgeInsets formMargin;
  final Color authButtonColor;
  final double backgroundBlur;
  final BackgroundType background;

  const LoginTheme(this.background, {
    required this.formMargin,
    required this.authButtonColor,
    required this.backgroundBlur
  });

  @override
  ThemeExtension<LoginTheme> copyWith() {
    // TODO: implement copyWith
    throw UnimplementedError();
  }

  @override
  ThemeExtension<LoginTheme> lerp(covariant ThemeExtension<LoginTheme>? other, double t) {
    // TODO: implement lerp
    throw UnimplementedError();
  }

  // 简约风格配置
  static const minimalTheme = LoginTheme(
      BackgroundType.gradient,
      formMargin: EdgeInsets.symmetric(horizontal: 40),
      authButtonColor: Colors.blueAccent,
      backgroundBlur: 0,
  );

// 商务风格配置
  static const businessTheme = LoginTheme(
      BackgroundType.image,
      formMargin: EdgeInsets.zero,
      authButtonColor: Colors.indigo,
      backgroundBlur: 5
  );

// 在main.dart全局初始化：
// MaterialApp(theme: ThemeData(extensions: [LoginTheme.minimal()]))
}