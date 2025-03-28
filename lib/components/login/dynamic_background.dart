import 'package:best_fish/components/login/particle_config.dart';
import 'package:flutter/material.dart';

enum BackgroundType { image, gradient, particle }

class DynamicBackground extends StatelessWidget {
  final BackgroundType type;
  final String? imageAsset;
  final List<Color> gradientColors;
  final ParticleOptions particleConfig;

  const DynamicBackground({
    super.key,
    required this.type,
    this.imageAsset,
    this.gradientColors = const [Colors.blue, Colors.purple],
    this.particleConfig = const ParticleOptions(
      particleCount: 50,
      baseColor: Colors.white,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: switch (type) {
        BackgroundType.image => _buildImageBackground(),
        BackgroundType.gradient => _buildGradientBackground(),
        // 动画暂时有问题先不实现
        BackgroundType.particle => _buildImageBackground(),
      },
    );
  }

  Widget _buildImageBackground() {
    assert(imageAsset != null, '图片背景必须提供imageAsset参数');
    return Stack(
      children: [
        Image.asset(
          imageAsset!,
          fit: BoxFit.cover,
        ),
        // 添加蒙层（网页2的视觉效果优化）
        Container(color: Colors.black.withOpacity(0.2)),
      ],
    );
  }

  Widget _buildGradientBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.2, 0.8],
        ),
      ),
    );
  }


}