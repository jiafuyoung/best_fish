
import 'package:flutter/material.dart';

class ParticleOptions {
  final int particleCount;
  final Color baseColor;
  final double maxSize;
  final double speed;

  const ParticleOptions({
    this.particleCount = 100,
    this.baseColor = Colors.white,
    this.maxSize = 5.0,
    this.speed = 1.0,

  });



  // 实现copyWith方法（网页3的Builder模式）
  ParticleOptions copyWith({
    int? particleCount,
    Color? baseColor,
    double? maxSize,
    double? speed,
    double? width,
    double? height,
  }) {
    return ParticleOptions(
      particleCount: particleCount ?? this.particleCount,
      baseColor: baseColor ?? this.baseColor,
      maxSize: maxSize ?? this.maxSize,
      speed: speed ?? this.speed,
    );
  }
}