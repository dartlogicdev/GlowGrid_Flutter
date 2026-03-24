import 'package:flutter/material.dart';
import '../models/light_segment.dart';

class LightPainter extends CustomPainter {
  final List<LightSegment> segments;
  final double cellSize;
  final double offsetX;
  final double offsetY;

  const LightPainter({
    required this.segments,
    required this.cellSize,
    required this.offsetX,
    required this.offsetY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final seg in segments) {
      final p1 = Offset(
        offsetX + seg.x1 * cellSize,
        offsetY + seg.y1 * cellSize,
      );
      final p2 = Offset(
        offsetX + seg.x2 * cellSize,
        offsetY + seg.y2 * cellSize,
      );

      // Wide outer glow.
      final glowPaint = Paint()
        ..color = seg.color.withAlpha(60)
        ..strokeWidth = 12
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawLine(p1, p2, glowPaint);

      // Medium mid-glow.
      final midPaint = Paint()
        ..color = seg.color.withAlpha(140)
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      canvas.drawLine(p1, p2, midPaint);

      // Bright core.
      final corePaint = Paint()
        ..color = seg.color
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(p1, p2, corePaint);
    }
  }

  @override
  bool shouldRepaint(LightPainter old) =>
      old.segments != segments ||
      old.cellSize != cellSize ||
      old.offsetX != offsetX ||
      old.offsetY != offsetY;
}
