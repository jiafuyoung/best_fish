import 'package:best_fish/components/login/models/form_config.dart'
    show FieldType, FormFieldConfig;
import 'package:best_fish/components/login/styles/minimal_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:best_fish/services/auth_service.dart';
import '../components/login/auth_form.dart';
import '../components/login/dynamic_background.dart'; // 新增引入

import '../routes/app_pages.dart';
import '../services/auth/enums.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final LoginTheme style; // 接收风格参数

  LoginScreen({super.key, this.style = LoginTheme.businessTheme});

  // 提交表单
  Future<void> _submit() async {
    // if (_formKey.currentState!.validate()) {
    //   final success = await Get.find<AuthService>().login(
    //     _emailController.text,
    //     _passwordController.text,
    //   );
    //   if (success) Get.offAllNamed(Routes.HOME);
    // }
    // 先无条件跳转
    if (kDebugMode) {
      print("跳转 home 页");
    }
    Get.offAllNamed("/home");
    // Get.offAllNamed(Routes.HOME);s
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      // 背景组件保持全屏
      Positioned.fill(
        child: DynamicBackground(
          type: style.background,
          imageAsset: "images/img.png",
        ),
      ),

      // 表单区域增加定位约束（网页1的布局方案改进）
      Positioned.fill(
        top: 300,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                AuthForm(
                  fields: [
                    FormFieldConfig(
                      type: FieldType.email,
                      label: '电子邮箱',
                      controller: _emailController,
                    ),
                    FormFieldConfig(
                      type: FieldType.password,
                      label: '密码',
                      controller: _passwordController,
                    )
                  ],
                  authMethods: {
                    ThirdPartyPlatform.google: true,
                    ThirdPartyPlatform.apple: false,
                  },
                ),
                SizedBox(
                  height: 30,
                ),

                // 替换原有登录按钮代码块
                SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 5,
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.minPositive, 40),
                          ),
                          child: const Text('登录'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 5,
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            side: const BorderSide(color: Colors.blue),
                            minimumSize: const Size(double.minPositive, 40),
                          ),
                          child: const Text('注册'),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      )
    ]));
  }
}
