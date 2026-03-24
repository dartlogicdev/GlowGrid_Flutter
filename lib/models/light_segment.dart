import 'package:flutter/material.dart';

/// A segment of a light beam drawn on the grid.
class LightSegment {
  final double x1, y1, x2, y2;
  final Color color;

  const LightSegment({
    required this.x1,
    required this.y1,
    required this.x2,
    required this.y2,
    required this.color,
  });
}
