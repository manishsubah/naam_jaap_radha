import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class PetalBurst extends StatefulWidget {
  const PetalBurst({super.key, required this.trigger});

  final int trigger;

  @override
  State<PetalBurst> createState() => _PetalBurstState();
}

class _PetalBurstState extends State<PetalBurst> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  );
  final _random = math.Random();
  List<_Petal> _petals = const [];

  @override
  void didUpdateWidget(PetalBurst oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger != oldWidget.trigger && widget.trigger > 0) {
      _petals = List.generate(36, (_) => _Petal.random(_random));
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _PetalPainter(_controller, _petals),
        size: Size.infinite,
      ),
    );
  }
}

class _Petal {
  const _Petal(this.angle, this.speed, this.spin, this.size, this.color);

  factory _Petal.random(math.Random r) => _Petal(
        r.nextDouble() * 2 * math.pi,
        0.35 + r.nextDouble() * 0.5,
        (r.nextDouble() - 0.5) * 8,
        6 + r.nextDouble() * 8,
        AppColors.petals[r.nextInt(AppColors.petals.length)],
      );

  final double angle;
  final double speed;
  final double spin;
  final double size;
  final Color color;
}

class _PetalPainter extends CustomPainter {
  _PetalPainter(this.animation, this.petals) : super(repaint: animation);

  final Animation<double> animation;
  final List<_Petal> petals;

  @override
  void paint(Canvas canvas, Size size) {
    final t = animation.value;
    if (t == 0 || t == 1 || petals.isEmpty) return;

    final center = size.center(Offset.zero);
    final reach = size.shortestSide * 0.6;
    final eased = Curves.easeOutCubic.transform(t);
    final opacity = (1 - t).clamp(0.0, 1.0);

    for (final p in petals) {
      final distance = reach * p.speed * eased;
      final gravity = size.height * 0.25 * t * t;
      final pos = center + Offset(math.cos(p.angle) * distance, math.sin(p.angle) * distance + gravity);
      canvas.save();
      canvas.translate(pos.dx, pos.dy);
      canvas.rotate(p.angle + p.spin * t);
      canvas.drawOval(
        Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 1.8),
        Paint()..color = p.color.withValues(alpha: opacity),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_PetalPainter oldDelegate) => oldDelegate.petals != petals;
}
