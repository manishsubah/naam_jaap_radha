import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class MalaPainter extends CustomPainter {
  MalaPainter({
    required this.total,
    required this.filled,
    required this.pulse,
    required this.threadColor,
  }) : super(repaint: pulse);

  final int total;
  final int filled;
  final Animation<double> pulse;
  final Color threadColor;

  static const _sumeruGap = 1.6;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2 - size.shortestSide * 0.08;
    final slots = total + _sumeruGap;
    final step = 2 * math.pi / slots;
    final beadRadius = math.min(radius * math.sin(step / 2) * 0.92, radius * 0.07);

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = threadColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    final pulseValue = Curves.easeOut.transform(1 - pulse.value);

    for (var i = 0; i < total; i++) {
      final angle = math.pi / 2 + step * (i + _sumeruGap / 2 + 0.5);
      final pos = center + Offset(math.cos(angle), math.sin(angle)) * radius;
      final isDone = i < filled;
      final isCurrent = i == filled - 1;
      final r = isCurrent ? beadRadius * (1 + 0.45 * pulseValue) : beadRadius;

      if (isCurrent) {
        canvas.drawCircle(
          pos,
          r * 2.2,
          Paint()
            ..color = AppColors.marigold.withValues(alpha: 0.35 * pulseValue + 0.15)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
        );
      }
      _drawBead(
        canvas,
        pos,
        r,
        isDone
            ? const [AppColors.lightGold, AppColors.gold, AppColors.kesari]
            : const [Color(0xFFB07A4A), AppColors.rudraksha, AppColors.rudrakshaDark],
      );
    }

    final sumeruPos = center + Offset(0, radius);
    final sumeruR = beadRadius * 1.7;
    final tassel = Paint()
      ..color = AppColors.maroon
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    for (var k = -3; k <= 3; k++) {
      canvas.drawLine(
        sumeruPos + Offset(0, sumeruR),
        sumeruPos + Offset(k * sumeruR * 0.28, sumeruR * 3.2),
        tassel,
      );
    }
    _drawBead(canvas, sumeruPos, sumeruR, const [AppColors.lotus, AppColors.maroon, Color(0xFF4A0E0E)]);
  }

  void _drawBead(Canvas canvas, Offset pos, double r, List<Color> colors) {
    final rect = Rect.fromCircle(center: pos, radius: r);
    canvas.drawCircle(
      pos,
      r,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.35, -0.35),
          colors: colors,
          stops: const [0, 0.55, 1],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(MalaPainter oldDelegate) =>
      oldDelegate.total != total || oldDelegate.filled != filled || oldDelegate.threadColor != threadColor;
}
