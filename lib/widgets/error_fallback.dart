// lib/widgets/error_fallback.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart'; // 需要添加lottie依赖
import 'package:best_fish/constants/app_assets.dart';

class ErrorFallbackWidget extends StatelessWidget {
  final FlutterErrorDetails errorDetails;

  const ErrorFallbackWidget(this.errorDetails, {super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(AppAssets.errorAnimation, width: 200),
            const SizedBox(height: 20),
            Text(
              '应用遇到异常',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              errorDetails.exceptionAsString(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Get.offAllNamed('/home'),
                  child: const Text('返回首页'),
                ),
                ElevatedButton(
                  onPressed: () => Get.offAllNamed('/login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: const Text('重新登录'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}