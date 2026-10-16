import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:naam_jaap/core/theme/app_colors.dart';

class GoalRing extends StatelessWidget {
  const GoalRing({
    super.key,
    required this.progress,
    required this.child,
    this.size = 200,
    this.strokeWidth = 16,
  });

  final double progress;
  final Widget child;
  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final track = Theme.of(context).colorScheme.primary.withValues(alpha: 0.12);
    return TweenAnimationBuilder<double>(
      tween: Tween(end: progress.clamp(0.0, 1.0)),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) => SizedBox.square(
        dimension: size,
        child: CustomPaint(
          painter: _GoalRingPainter(progress: value, track: track, strokeWidth: strokeWidth),
          child: Center(child: child),
        ),
      ),
    );
  }
}

class _GoalRingPainter extends CustomPainter {
  _GoalRingPainter({required this.progress, required this.track, required this.strokeWidth});

  final double progress;
  final Color track;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final arcRect = rect.deflate(strokeWidth / 2);

    canvas.drawArc(
      arcRect,
      0,
      2 * math.pi,
      false,
      Paint()
        ..color = track
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    if (progress <= 0) return;

    final sweep = 2 * math.pi * progress;
    final paint = Paint()
      ..shader = const SweepGradient(
        startAngle: 0,
        endAngle: 2 * math.pi,
        colors: [AppColors.saffron, AppColors.marigold, AppColors.gold, AppColors.kesari, AppColors.saffron],
        transform: GradientRotation(-math.pi / 2),
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    canvas.drawArc(arcRect, -math.pi / 2, sweep, false, paint);
  }

  @override
  bool shouldRepaint(_GoalRingPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.track != track;
}
