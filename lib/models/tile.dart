import 'package:flutter/material.dart';
import 'tile_type.dart';

/// A single cell in the GlowGrid puzzle.
class Tile {
  final int x;
  final int y;
  final TileType type;

  /// Rotation in steps of 90° (0–3 → 0°, 90°, 180°, 270°).
  int rotation;

  /// The colour carried by an emitter or receiver (ARGB hex, e.g. 0xFF00E5FF).
  final Color? color;

  /// Set by the light algorithm each frame.
  bool isLit;
  Color? litColor;

  Tile({
    required this.x,
    required this.y,
    required this.type,
    this.rotation = 0,
    this.color,
    this.isLit = false,
    this.litColor,
  });

  /// Rotate 90° clockwise.
  void rotate() => rotation = (rotation + 1) % 4;

  /// Create from a level JSON tile entry.
  factory Tile.fromJson(Map<String, dynamic> json) {
    TileType type;
    switch (json['type'] as String) {
      case 'emitter':
        type = TileType.emitter;
        break;
      case 'receiver':
        type = TileType.receiver;
        break;
      case 'mirror':
        type = TileType.mirror;
        break;
      case 'splitter':
        type = TileType.splitter;
        break;
      case 'prism':
        type = TileType.prism;
        break;
      default:
        type = TileType.empty;
    }

    // Direction → rotation for emitters (right=0, down=1, left=2, up=3).
    int rotation = json['rot'] as int? ?? 0;
    if (json.containsKey('dir')) {
      const dirMap = {'right': 0, 'down': 1, 'left': 2, 'up': 3};
      rotation = dirMap[json['dir']] ?? 0;
    }

    Color? color;
    if (json.containsKey('color')) {
      final raw = json['color'] as String;
      color = Color(int.parse(raw));
    }

    return Tile(
      x: json['x'] as int,
      y: json['y'] as int,
      type: type,
      rotation: rotation,
      color: color,
    );
  }

  Tile copyWith({int? rotation, bool? isLit, Color? litColor}) => Tile(
    x: x,
    y: y,
    type: type,
    rotation: rotation ?? this.rotation,
    color: color,
    isLit: isLit ?? this.isLit,
    litColor: litColor ?? this.litColor,
  );
}
