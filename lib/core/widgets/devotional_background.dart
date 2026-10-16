import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class DevotionalBackground extends StatelessWidget {
  const DevotionalBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark
        ? const [AppColors.nightGlow, AppColors.night, AppColors.night]
        : const [Color(0xFFFFE3B8), AppColors.cream, AppColors.cream];

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
          stops: const [0, 0.45, 1],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -80,
            right: -80,
            child: IgnorePointer(
              child: CustomPaint(
                size: const Size(260, 260),
                painter: MandalaPainter(
                  color: AppColors.gold.withValues(alpha: isDark ? 0.12 : 0.18),
                ),
              ),
            ),
          ),
          Positioned.fill(child: child),
        ],
      ),
    );
  }
}

class MandalaPainter extends CustomPainter {
  MandalaPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    for (final f in [0.25, 0.5, 0.75, 1.0]) {
      canvas.drawCircle(center, radius * f, stroke);
    }

    for (final ring in [(count: 8, at: 0.38, w: 0.12, h: 0.24), (count: 16, at: 0.72, w: 0.09, h: 0.2)]) {
      for (var i = 0; i < ring.count; i++) {
        final angle = i * 2 * math.pi / ring.count;
        canvas.save();
        canvas.translate(center.dx, center.dy);
        canvas.rotate(angle);
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(0, -radius * ring.at),
            width: radius * ring.w,
            height: radius * ring.h,
          ),
          stroke,
        );
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(MandalaPainter oldDelegate) => oldDelegate.color != color;
}
