import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class DiyaGlow extends StatefulWidget {
  const DiyaGlow({super.key, this.size = 64});

  final double size;

  @override
  State<DiyaGlow> createState() => _DiyaGlowState();
}

class _DiyaGlowState extends State<DiyaGlow> with SingleTickerProviderStateMixin {
  late final AnimationController _flicker = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..repeat();

  @override
  void dispose() {
    _flicker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: CustomPaint(painter: _DiyaPainter(_flicker)),
    );
  }
}

class _DiyaPainter extends CustomPainter {
  _DiyaPainter(this.animation) : super(repaint: animation);

  final Animation<double> animation;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final t = animation.value * 2 * math.pi;
    final sway = math.sin(t) * w * 0.025 + math.sin(t * 2.7) * w * 0.012;
    final stretch = 1 + math.sin(t * 1.9) * 0.06;

    final flameBase = Offset(w / 2, h * 0.58);
    canvas.drawCircle(
      Offset(w / 2, h * 0.42),
      w * 0.42,
      Paint()
        ..shader = RadialGradient(
          colors: [AppColors.marigold.withValues(alpha: 0.45), AppColors.marigold.withValues(alpha: 0)],
        ).createShader(Rect.fromCircle(center: Offset(w / 2, h * 0.42), radius: w * 0.42)),
    );

    final flameHeight = h * 0.42 * stretch;
    final flame = Path()
      ..moveTo(flameBase.dx, flameBase.dy)
      ..quadraticBezierTo(
        flameBase.dx - w * 0.14, flameBase.dy - flameHeight * 0.45,
        flameBase.dx + sway, flameBase.dy - flameHeight,
      )
      ..quadraticBezierTo(
        flameBase.dx + w * 0.14, flameBase.dy - flameHeight * 0.45,
        flameBase.dx, flameBase.dy,
      );
    canvas.drawPath(
      flame,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [AppColors.kesari, AppColors.marigold, Color(0xFFFFF3C4)],
        ).createShader(Rect.fromLTWH(0, flameBase.dy - flameHeight, w, flameHeight)),
    );

    final bowl = Path()
      ..moveTo(w * 0.12, h * 0.6)
      ..quadraticBezierTo(w / 2, h * 1.0, w * 0.88, h * 0.6)
      ..quadraticBezierTo(w / 2, h * 0.7, w * 0.12, h * 0.6)
      ..close();
    canvas.drawPath(
      bowl,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.gold, AppColors.rudraksha],
        ).createShader(Rect.fromLTWH(0, h * 0.58, w, h * 0.4)),
    );
  }

  @override
  bool shouldRepaint(_DiyaPainter oldDelegate) => false;
}
