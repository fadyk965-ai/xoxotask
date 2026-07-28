import 'dart:math';
import 'package:flutter/material.dart';

class ParticleEffectPainter extends CustomPainter {
  final Animation<double> progress;
  final bool isWin;

  ParticleEffectPainter({required this.progress, required this.isWin}) : super(repaint: progress);

  @override
  void paint(Canvas canvas, Size size) {
    if (progress.value == 0 || progress.value == 1) return;

    final random = Random(42);
    final paint = Paint()
      ..color = isWin ? const Color(0xFF05D9E8) : const Color(0xFFFF2A6D)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 60; i++) {
      double speed = random.nextDouble() * 300 + 100;
      double angle = random.nextDouble() * 2 * pi;
      double radius = random.nextDouble() * 6 + 2;

      double dx = size.width / 2 + cos(angle) * speed * progress.value;
      double dy = size.height / 2 + sin(angle) * speed * progress.value;
      double opacity = (1.0 - progress.value).clamp(0.0, 1.0);

      paint.color = (isWin ? const Color(0xFF05D9E8) : const Color(0xFFFF2A6D)).withOpacity(opacity);
      canvas.drawCircle(Offset(dx, dy), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticleEffectPainter oldDelegate) => true;
}

