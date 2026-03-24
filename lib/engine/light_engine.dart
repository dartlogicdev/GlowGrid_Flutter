import 'package:flutter/material.dart';
import '../models/tile_type.dart';
import '../models/level.dart';
import '../models/light_segment.dart';

// Cardinal directions: 0=right, 1=down, 2=left, 3=up.
const List<int> _dx = [1, 0, -1, 0];
const List<int> _dy = [0, 1, 0, -1];

class LightEngine {
  static const List<Color> _emitterPalette = [
    Color(0xFF00E5FF), // cyan
    Color(0xFFBB88FF), // purple
    Color(0xFF00FF88), // green
    Color(0xFFFFBB00), // amber
    Color(0xFFFF4466), // pink
  ];

  /// Traces all beams and returns:
  ///  - a list of [LightSegment] for drawing.
  ///  - a map from receiver tile key ("x,y") → lit Color.
  static ({List<LightSegment> segments, Map<String, Color> litReceivers})
  trace(Level level, {bool multiColor = false}) {
    final segments = <LightSegment>[];
    final litReceivers = <String, Color>{};

    // Queue entry: (x, y, direction, color)
    final queue = <_Ray>[];

    // Seed from emitters.
    final emitters = level.emitters;
    for (int i = 0; i < emitters.length; i++) {
      final tile = emitters[i];
      final color = multiColor
          ? _emitterPalette[i % _emitterPalette.length]
          : (tile.color ?? const Color(0xFF00E5FF));
      queue.add(_Ray(x: tile.x, y: tile.y, dir: tile.rotation, color: color));
    }

    // Visited set to prevent infinite loops.
    final visited = <String>{};

    while (queue.isNotEmpty) {
      final ray = queue.removeAt(0);

      // Step to the next cell in ray's direction.
      final nx = ray.x + _dx[ray.dir];
      final ny = ray.y + _dy[ray.dir];

      // Segment from current cell centre → next cell centre (in grid coords).
      segments.add(LightSegment(
        x1: ray.x + 0.5,
        y1: ray.y + 0.5,
        x2: nx + 0.5,
        y2: ny + 0.5,
        color: ray.color,
      ));

      // Out of bounds → beam exits grid.
      if (nx < 0 || ny < 0 || nx >= level.gridSize || ny >= level.gridSize) {
        continue;
      }

      final key = '${nx}_${ny}_${ray.dir}_${ray.color.toARGB32()}';
      if (visited.contains(key)) continue;
      visited.add(key);

      final tile = level.tileAt(nx, ny);

      switch (tile.type) {
        case TileType.empty:
          // Continue straight.
          queue.add(_Ray(x: nx, y: ny, dir: ray.dir, color: ray.color));
          break;

        case TileType.emitter:
          // Emitters block beams that hit them.
          break;

        case TileType.receiver:
          final rKey = '$nx,$ny';
          litReceivers[rKey] = _blendColors(litReceivers[rKey], ray.color);
          break;

        case TileType.mirror:
          // rotation 0 & 2 = "/" mirror, rotation 1 & 3 = "\" mirror.
          final newDir = _mirrorDeflect(ray.dir, tile.rotation);
          queue.add(_Ray(x: nx, y: ny, dir: newDir, color: ray.color));
          break;

        case TileType.splitter:
          // rotation 0 & 2 = horizontal "—", rotation 1 & 3 = vertical "|".
          final outDirs = _splitterDirs(ray.dir, tile.rotation);
          for (final d in outDirs) {
            queue.add(_Ray(x: nx, y: ny, dir: d, color: ray.color));
          }
          break;

        case TileType.prism:
          // Splits into the two perpendicular directions, mixing white component.
          final perp1 = (ray.dir + 1) % 4;
          final perp2 = (ray.dir + 3) % 4;
          queue.add(_Ray(x: nx, y: ny, dir: perp1, color: ray.color));
          queue.add(_Ray(x: nx, y: ny, dir: perp2, color: ray.color));
          // Beam also passes through.
          queue.add(_Ray(x: nx, y: ny, dir: ray.dir, color: ray.color));
          break;
      }
    }

    return (segments: segments, litReceivers: litReceivers);
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

class _Ray {
  final int x, y, dir;
  final Color color;
  const _Ray({required this.x, required this.y, required this.dir, required this.color});
}

/// Mirror deflection table.
///   Rotation 0 & 2 → "/" mirror:  right→up, down→left, left→down, up→right
///   Rotation 1 & 3 → "\" mirror:  right→down, down→right, left→up, up→left
int _mirrorDeflect(int dir, int rotation) {
  if (rotation % 2 == 0) {
    // "/" mirror
    const map = [3, 2, 1, 0]; // right→up, down→left, left→down, up→right
    return map[dir];
  } else {
    // "\" mirror
    const map = [1, 0, 3, 2]; // right→down, down→right, left→up, up→left
    return map[dir];
  }
}

/// Splitter output directions.
List<int> _splitterDirs(int dir, int rotation) {
  final bool horizontal = rotation % 2 == 0;
  if (horizontal) {
    // "—": left/right pass through; up/down split to left+right.
    if (dir == 0 || dir == 2) return [dir];
    return [0, 2];
  } else {
    // "|": up/down pass through; left/right split to up+down.
    if (dir == 1 || dir == 3) return [dir];
    return [1, 3];
  }
}

/// Blend two nullable colours together (additive clamped).
Color _blendColors(Color? a, Color b) {
  if (a == null) return b;
  return Color.fromARGB(
    255,
    (a.r * 255 + b.r * 255).clamp(0, 255).toInt(),
    (a.g * 255 + b.g * 255).clamp(0, 255).toInt(),
    (a.b * 255 + b.b * 255).clamp(0, 255).toInt(),
  );
}
