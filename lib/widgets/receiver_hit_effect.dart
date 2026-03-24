import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../state/settings_state.dart';

/// Wraps a receiver tile and overlays the chosen hit-effect
/// whenever [isLit] flips from false → true.
class ReceiverHitEffect extends StatefulWidget {
  final bool isLit;
  final Color color;
  final ReceiverEffect effect;
  final Widget child;

  const ReceiverHitEffect({
    super.key,
    required this.isLit,
    required this.color,
    required this.effect,
    required this.child,
  });

  @override
  State<ReceiverHitEffect> createState() => _ReceiverHitEffectState();
}

class _ReceiverHitEffectState extends State<ReceiverHitEffect>
    with TickerProviderStateMixin {
  // ── Particle burst ──────────────────────────────────────────────────────────
  late final AnimationController _particleCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  );

  // ── Glow pulse ──────────────────────────────────────────────────────────────
  late final AnimationController _glowCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  )..addStatusListener((status) {
      if (status == AnimationStatus.completed && widget.isLit) {
        _glowCtrl.reverse();
      } else if (status == AnimationStatus.dismissed && widget.isLit) {
        _glowCtrl.forward();
      }
    });

  bool _wasLit = false;

  @override
  void didUpdateWidget(ReceiverHitEffect old) {
    super.didUpdateWidget(old);
    if (widget.isLit && !_wasLit) {
      // Receiver just got activated.
      if (widget.effect == ReceiverEffect.particles) {
        _particleCtrl.forward(from: 0);
      } else if (widget.effect == ReceiverEffect.glow) {
        _glowCtrl.forward(from: 0);
      }
    } else if (!widget.isLit) {
      _glowCtrl.stop();
      _glowCtrl.value = 0;
    }
    _wasLit = widget.isLit;
  }

  @override
  void dispose() {
    _particleCtrl.dispose();
    _glowCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Glow ring
        if (widget.effect == ReceiverEffect.glow && widget.isLit)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _glowCtrl,
              builder: (_, __) {
                final t = _glowCtrl.value;
                return DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: widget.color
                            .withAlpha((100 + (120 * t)).toInt()),
                        blurRadius: 8 + 16 * t,
                        spreadRadius: 1 + 4 * t,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

        // Child tile
        widget.child,

        // Particle burst
        if (widget.effect == ReceiverEffect.particles)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _particleCtrl,
              builder: (_, __) {
                if (_particleCtrl.value == 0) return const SizedBox.shrink();
                return CustomPaint(
                  painter: _ParticlePainter(
                    progress: _particleCtrl.value,
                    color: widget.color,
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

// ── Particle painter ─────────────────────────────────────────────────────────

class _ParticlePainter extends CustomPainter {
  final double progress; // 0 → 1
  final Color color;

  static const int _count = 10;
  static final List<double> _angles = List.generate(
    _count,
    (i) => (2 * math.pi / _count) * i,
  );

  const _ParticlePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1) return;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final maxRadius = size.shortestSide * 1.4;
    final alpha = ((1 - progress) * 255).toInt().clamp(0, 255);
    final paint = Paint()
      ..color = color.withAlpha(alpha)
      ..style = PaintingStyle.fill;

    for (final angle in _angles) {
      final r = maxRadius * _easeOut(progress);
      final x = cx + r * math.cos(angle);
      final y = cy + r * math.sin(angle);
      final dotRadius = (3 * (1 - progress)).clamp(0.5, 4.0);
      canvas.drawCircle(Offset(x, y), dotRadius, paint);
    }
  }

  double _easeOut(double t) => 1 - math.pow(1 - t, 2).toDouble();

  @override
  bool shouldRepaint(_ParticlePainter old) => old.progress != progress;
}
